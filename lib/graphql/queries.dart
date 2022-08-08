String get getOrderbook => /* GraphQL */ '''
  query GetOrderbook(\$market: String!, \$limit: Int, \$nextToken: String) {
    getOrderbook(market: \$market, limit: \$limit, nextToken: \$nextToken) {
      items {
        p
        q
        s
      }
      nextToken
    }
  }
''';
String get getKlinesbyMarketInterval => /* GraphQL */ '''
  query GetKlinesbyMarketInterval(
    \$market: String!
    \$interval: String!
    \$from: AWSDateTime!
    \$to: AWSDateTime!
  ) {
    getKlinesbyMarketInterval(
      market: \$market
      interval: \$interval
      from: \$from
      to: \$to
    ) {
      items {
        o
        c
        h
        l
        v_base
        v_quote
        nt
        time
      }
    }
  }
''';
String get getAllAssets => /* GraphQL */ '''
  query GetAllAssets(\$limit: Int, \$nextToken: String) {
    getAllAssets(limit: \$limit, nextToken: \$nextToken) {
      items {
        ticker
        withdrawal_fee
      }
      nextToken
    }
  }
''';
String get getRecentTrades => /* GraphQL */ '''
  query GetRecentTrades(\$m: String!, \$limit: Int, \$nextToken: String) {
    getRecentTrades(m: \$m, limit: \$limit, nextToken: \$nextToken) {
      items {
        m
        t
        p
        q
      }
      nextToken
    }
  }
''';
String get getAllMarketTickers => /* GraphQL */ '''
  query GetAllMarketTickers {
    getAllMarketTickers {
      items {
        m
        pc
        pcp
        o
        c
        h
        l
        v_base
        v_quote
        nt
      }
      nextToken
    }
  }
''';
String get getAllMarkets => /* GraphQL */ '''
  query GetAllMarkets {
    getAllMarkets {
      items {
        market
        max_trade_amount
        min_trade_amount
        min_qty
      }
    }
  }
''';
String get findUserByProxyAccount => /* GraphQL */ '''
  query FindUserByProxyAccount(\$proxy_account: String!) {
    findUserByProxyAccount(proxy_account: \$proxy_account) {
      items
      nextToken
    }
  }
''';
String get findUserByMainAccount => /* GraphQL */ '''
  query FindUserByMainAccount(\$main_account: String!) {
    findUserByMainAccount(main_account: \$main_account) {
      proxies
    }
  }
''';
String get findBalanceByMainAccount => /* GraphQL */ '''
  query FindBalanceByMainAccount(\$main_account: String!, \$asset: String!) {
    findBalanceByMainAccount(main_account: \$main_account, asset: \$asset) {
      a
      f
      r
      p
    }
  }
''';
String get getAllBalancesByMainAccount => /* GraphQL */ '''
  query GetAllBalancesByMainAccount(\$main_account: String!) {
    getAllBalancesByMainAccount(main_account: \$main_account) {
      items {
        a
        f
        r
        p
      }
      nextToken
    }
  }
''';
String get findOrderByMainAccount => /* GraphQL */ '''
  query FindOrderByMainAccount(
    \$main_account: String!
    \$order_id: String!
    \$market: String!
  ) {
    findOrderByMainAccount(
      main_account: \$main_account
      order_id: \$order_id
      market: \$market
    ) {
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
String get listOrderHistorybyMainAccount => /* GraphQL */ '''
  query ListOrderHistorybyMainAccount(
    \$main_account: String!
    \$from: AWSDateTime!
    \$to: AWSDateTime!
    \$limit: Int
    \$nextToken: String
  ) {
    listOrderHistorybyMainAccount(
      main_account: \$main_account
      from: \$from
      to: \$to
      limit: \$limit
      nextToken: \$nextToken
    ) {
      items {
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
      nextToken
    }
  }
''';
String get listOpenOrdersByMainAccount => /* GraphQL */ '''
  query ListOpenOrdersByMainAccount(
    \$main_account: String!
    \$limit: Int
    \$nextToken: String
  ) {
    listOpenOrdersByMainAccount(
      main_account: \$main_account
      limit: \$limit
      nextToken: \$nextToken
    ) {
      items {
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
      nextToken
    }
  }
''';
String get listTransactionsByMainAccount => /* GraphQL */ '''
  query ListTransactionsByMainAccount(
    \$main_account: String!
    \$from: AWSDateTime!
    \$to: AWSDateTime!
    \$limit: Int
    \$nextToken: String
  ) {
    listTransactionsByMainAccount(
      main_account: \$main_account
      from: \$from
      to: \$to
      limit: \$limit
      nextToken: \$nextToken
    ) {
      items {
        tt
        a
        q
        fee
        st
        t
      }
      nextToken
    }
  }
''';
String get listTradesByMainAccount => /* GraphQL */ '''
  query ListTradesByMainAccount(
    \$main_account: String!
    \$from: AWSDateTime!
    \$to: AWSDateTime!
    \$limit: Int
    \$nextToken: String
  ) {
    listTradesByMainAccount(
      main_account: \$main_account
      from: \$from
      to: \$to
      limit: \$limit
      nextToken: \$nextToken
    ) {
      items {
        m
        p
        q
        s
        t
      }
      nextToken
    }
  }
''';
