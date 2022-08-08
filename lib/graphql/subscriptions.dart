String get websocketStreams => /* GraphQL */ '''
subscription Websocket_streams(\$name: String!) {
    websocket_streams(name: \$name) {
      name
      data
    }
  }
''';
