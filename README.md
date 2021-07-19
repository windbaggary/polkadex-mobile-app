# Polkadex

A new Flutter project for Polkadex

## Getting Started

The source code of the project is maintaned using Google's code style recommendations for Dart: <https://dart.dev/guides/language/effective-dart/style>. To make sure the code being written is following these recommendations, put the pre-commit script provided in the project root in your .git/hooks/pre-commit by running the following command:

    cp pre-commit .git/hooks/pre-commit

The project is maintained based on the provider architecture.

## Provider Architecture

A wrapper around InheritedWidget to make them easier to use and more reusable.

By using provider instead of manually writing InheritedWidget, you get:

simplified allocation/disposal of resources
lazy-loading
a largely reduced boilerplate over making a new class every time
devtools friendly
a common way to consume these InheritedWidgets (See Provider.of/Consumer/Selector)
increased scalability for classes with a listening mechanism that grows exponentially in complexity (such as ChangeNotifier, which is O(N²) for dispatching notifications).

To read more about provider, see its documentation.
https://pub.dev/documentation/provider/latest/provider/provider-library.html

## Project Structure

The project is structured as below

    - Configs
        Any configuration classes are included in this folder. Like App configurations, DB Configurations, etc.
    
    - Features
        The project is divided into features based on the screen types or logic types. Each features contains the below structure

        - Providers
            The common public providers which are using in this features
        - Screens
            The public screens for the feature
        - Widgets
            The public widgets for the feature
        - models
            Any models for the widgets or screens or any data transfering between UI modules
        - sub_views
            Any subview such as tabview, inner screens, etc are included in this folder
        - dialogs
            The popups or dialogs are created in this folder
    
    - Providers
        Any public providers which are needs for multiple features are declared in this folder

    - Utils
        The utilies such as colors, stylesheets are defined in this folder
    - Widgets
        Any public widgets which are needs for multiple features are declared in this folder


## Environment
    flutter doctor -v
    Flutter (Channel stable, 2.2.1, on macOS 11.4 20F71 darwin-x64, locale en-GB)
    • Flutter version 2.2.1 at /Applications/flutter
    • Framework revision 02c026b03c (6 weeks ago), 2021-05-27 12:24:44 -0700
    • Engine revision 0fdb562ac8
    • Dart version 2.13.1

