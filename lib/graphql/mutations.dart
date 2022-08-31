String get placeOrder => '''
  mutation Place_order(\$input: UserActionInput!) {
    place_order(input: \$input)
  }
''';

String get cancelOrder => /* GraphQL */ '''
  mutation Cancel_order(\$input: UserActionInput!) {
    cancel_order(input: \$input)
  }
''';
String get withdraw => /* GraphQL */ '''
  mutation Withdraw(\$input: UserActionInput!) {
    withdraw(input: \$input)
  }
''';
String get publish => /* GraphQL */ '''
  mutation Publish(\$name: String!, \$data: String!) {
    publish(name: \$name, data: \$data) {
      name
      data
    }
  }
''';
