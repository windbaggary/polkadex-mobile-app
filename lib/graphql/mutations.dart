String get placeOrder => '''
mutation Place_order(\$input: UserActionInput!) {
    place_order(input: \$input) {
      u
      cid
      id
      t
      m
      s
      ot
      st
      p
      q
      afp
      fq
      fee
    }
  }
''';

String get cancelOrder => /* GraphQL */ '''
mutation Cancel_order(\$input: UserActionInput!) {
    cancel_order(input: \$input) {
      u
      cid
      id
      t
      m
      s
      ot
      st
      p
      q
      afp
      fq
      fee
    }
  }
}
''';
String get withdraw => /* GraphQL */ '''
mutation Withdraw(\$input: UserActionInput!) {
    withdraw(input: \$input)
  }
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
