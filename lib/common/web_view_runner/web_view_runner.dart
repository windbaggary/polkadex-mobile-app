import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Class which contains a HeadlessInAppWebView to call Javascript functions
/// from files injected in the assets folder of the app project
///
/// Based on the same name class contained within the polkawallet_sdk library:
/// https://github.com/polkawallet-io/sdk
class WebViewRunner {
  HeadlessInAppWebView? _web;

  late String _jsCode;
  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  int _evalJavascriptUID = 0;

  bool _webViewLoaded = false;
  Timer? _webViewReloadTimer;

  Future<void> launch({
    required String jsCode,
  }) async {
    /// reset state before webView launch or reload
    _msgHandlers = {};
    _msgCompleters = {};
    _evalJavascriptUID = 0;
    _webViewLoaded = false;

    _jsCode = await rootBundle.loadString(jsCode);
    print('js file loaded');

    if (_web == null) {
      _web = HeadlessInAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(),
        ),
        onWebViewCreated: (controller) {
          print('HeadlessInAppWebView created!');
        },
        onConsoleMessage: (controller, message) {
          print("CONSOLE MESSAGE: " + message.message);
          if (message.messageLevel != ConsoleMessageLevel.LOG) return;

          compute(jsonDecode, message.message).then((msg) {
            final String path = msg['path'];
            if (_msgCompleters[path] != null) {
              Completer? handler = _msgCompleters[path];
              handler?.complete(msg['data']);
              if (path.contains('uid=')) {
                _msgCompleters.remove(path);
              }
            }
            if (_msgHandlers[path] != null) {
              Function? handler = _msgHandlers[path];
              handler!(msg['data']);
            }
          });
        },
        onLoadStop: (controller, url) async {
          print('webview loaded');
          _handleReloaded();
          await _startJSCode();
        },
      );

      await _web?.run();
      _web?.webViewController.loadUrl(
          urlRequest: URLRequest(url: Uri.parse("https://localhost:8080/")));
    } else {
      _tryReload();
    }
  }

  void _tryReload() {
    if (!_webViewLoaded) {
      _web?.webViewController.reload();

      _webViewReloadTimer = Timer(Duration(seconds: 3), _tryReload);
    }
  }

  void _handleReloaded() {
    _webViewReloadTimer?.cancel();
    _webViewLoaded = true;
  }

  Future<void> _startJSCode() async {
    // inject js file to webView
    await _web?.webViewController.evaluateJavascript(source: _jsCode);
  }

  int getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = true,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (String i in _msgCompleters.keys) {
        String call = code.split('(')[0];
        if (i.contains(call)) {
          print('request $call loading');
          return _msgCompleters[i]!.future;
        }
      }
    }

    if (!wrapPromise) {
      final res =
          await _web?.webViewController.evaluateJavascript(source: code);
      return res;
    }

    final c = Completer();

    final uid = getEvalJavascriptUID();
    final method = 'uid=$uid;${code.split('(')[0]}';
    _msgCompleters[method] = c;

    final script = '$code.then(function(res) {'
        '  console.log(JSON.stringify({ path: "$method", data: res }));'
        '}).catch(function(err) {'
        '  console.log(JSON.stringify({ path: "$method", data: err.message }));'
        '});$uid;';
    _web?.webViewController.evaluateJavascript(source: script);

    return c.future;
  }

  //Future<NetworkParams> connectNode(List<NetworkParams> nodes) async {
  //  final String? res = await evalJavascript(
  //      'settings.connect(${jsonEncode(nodes.map((e) => e.endpoint).toList())})');
  //  if (res != null) {
  //    final index = nodes.indexWhere((e) => e.endpoint.trim() == res.trim());
  //    return nodes[index > -1 ? index : 0];
  //  }
  //  return null;
  //}

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    addMsgHandler(channel, callback);
    evalJavascript(code);
  }

  void unsubscribeMessage(String channel) {
    print('unsubscribe $channel');
    final unsubCall = 'unsub$channel';
    _web?.webViewController
        .evaluateJavascript(source: 'window.$unsubCall && window.$unsubCall()');
  }

  void addMsgHandler(String channel, Function onMessage) {
    _msgHandlers[channel] = onMessage;
  }

  void removeMsgHandler(String channel) {
    _msgHandlers.remove(channel);
  }
}