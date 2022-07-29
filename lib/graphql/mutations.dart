String get setOrderbookPuts => '''
mutation SetOrderbookPuts(\$input: SetOrderbookInput!) {
setOrderbookPuts(input: \$input) {
price
qty
side
}
}
''';

String get setOrderbookDels => '''
mutation SetOrderbookDels(\$input: SetOrderbookInput!) {
setOrderbookDels(input: \$input) {
price
qty
side
}
}
''';

String get setTickerStats => '''
mutation SetTickerStats(\$input: TickerStatInput!) {
setTickerStats(input: \$input) {
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

String get publish => '''
mutation Publish(\$name: String!, \$data: String!) {
publish(name: \$name, data: \$data) {
name
data
}
}
''';

String get addProxy => '''
mutation AddProxy(\$main_account: String!, \$proxy_account: String!) {
addProxy(main_account: \$main_account, proxy_account: \$proxy_account) {
main_account
proxy_accounts
}
}
''';

String get removeProxy => '''
mutation RemoveProxy(\$main_account: String!, \$proxy_account: String!) {
removeProxy(main_account: \$main_account, proxy_account: \$proxy_account) {
main_account
proxy_accounts
}
}
''';

String get setBalance => '''
mutation SetBalance(\$input: BalanceUpdateInput!) {
setBalance(input: \$input) {
main_account
asset
free
reserved
pending_withdrawal
}
}
''';

String get setOrder => '''
mutation SetOrder(\$input: OrderUpdateInput!) {
setOrder(input: \$input) {
main_account
client_order_id
exchange_order_id
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

String get addNewTrade => '''
mutation AddNewTrade(\$input: AddNewTradeInput!) {
addNewTrade(input: \$input) {
main_account
m
p
q
time
}
}
''';

String get setTransaction => '''
mutation SetTransaction(\$input: TransactionUpdateInput!) {
setTransaction(input: \$input) {
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

String get setCandleStick => '''
mutation SetCandleStick(\$input: CandleStickInput!) {
setCandleStick(input: \$input) {
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
