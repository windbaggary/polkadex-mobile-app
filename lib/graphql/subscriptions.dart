String get onBalanceUpdate => /* GraphQL */ '''
subscription OnBalanceUpdate(\$main_account: String!) {
onBalanceUpdate(main_account: \$main_account) {
main_account
asset
free
reserved
pending_withdrawal
}
}
''';
String get onOrderUpdate => /* GraphQL */ '''
subscription OnOrderUpdate(\$main_account: String!) {
onOrderUpdate(main_account: \$main_account) {
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
String get onCreateTrade => /* GraphQL */ '''
subscription OnCreateTrade(\$main_account: String!) {
onCreateTrade(main_account: \$main_account) {
main_account
m
p
q
time
}
}
''';
String get onUpdateTransaction => /* GraphQL */ '''
subscription OnUpdateTransaction(\$main_account: String!) {
onUpdateTransaction(main_account: \$main_account) {
main_account
txn_type
asset
amount
fee
status
time
}
}
''';
String get onCandleStickEvents => /* GraphQL */ '''
subscription OnCandleStickEvents(\$m: String!, \$interval: String!) {
onCandleStickEvents(m: \$m, interval: \$interval) {
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
''';
String get websocketStreams => /* GraphQL */ '''
subscription Websocket_streams(\$name: String!) {
websocket_streams(name: \$name) {
name
data
}
}
''';
String get onNewTicker => /* GraphQL */ '''
subscription OnNewTicker(\$m: String!) {
onNewTicker(m: \$m) {
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
}
''';
