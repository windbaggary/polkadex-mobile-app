/* tslint:disable */
/* eslint-disable */
// this is an auto generated file. This will be overwritten

String get getChannel => /* GraphQL */ '''
query GetChannel {
getChannel {
name
data
}
}
''';

String get getOrderbook => /* GraphQL */ '''
query GetOrderbook(\$market: String!, \$limit: Int, \$nextToken: String) {
getOrderbook(market: \$market, limit: \$limit, nextToken: \$nextToken) {
items {
price
qty
side
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
m
interval
o
c
h
l
v_base
v_quote
t
}
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
priceChange24Hr
priceChangePercent24Hr
open
close
high
low
volumeBase24hr
volumeQuote24Hr
}
nextToken
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
main_account
proxy_accounts
}
}
''';

String get findBalanceByMainAccount => /* GraphQL */ '''
query FindBalanceByMainAccount(\$main_account: String!, \$asset: String!) {
findBalanceByMainAccount(main_account: \$main_account, asset: \$asset) {
main_account
asset
free
reserved
pending_withdrawal
}
}
''';

String get getAllBalancesByMainAccount => /* GraphQL */ '''
query GetAllBalancesByMainAccount(\$main_account: String!) {
getAllBalancesByMainAccount(main_account: \$main_account) {
items {
main_account
asset
free
reserved
pending_withdrawal
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
main_account
id
time
m
side
order_type
status
price
qty
avg_filled_price
filled_quantity
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
main_account
id
time
m
side
order_type
status
price
qty
avg_filled_price
filled_quantity
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
main_account
id
time
m
side
order_type
status
price
qty
avg_filled_price
filled_quantity
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
main_account
txn_type
asset
amount
fee
status
time
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
main_account
m
p
q
time
}
nextToken
}
}
''';
