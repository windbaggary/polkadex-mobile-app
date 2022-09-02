/// The enum for identifying the sliding steps
enum EnumCreateSliderSteps { step1, step2, step3 }

/// The enum for the ranking list sorting
/// Gainers, Losers, Vol
enum EnumRankingListSorts { gainers, losers, vol }

/// The enum for the drawer menu app settings
enum EnumDrawerAppSettings {
  notifications,
  appearance,
  languageCurrency,
  privacySecurtiy,
  myAccount,
}

/// The enum for the drawer menu app settings
enum EnumDrawerAppInfo {
  termsConditions,
  privacyPolicy,
  helpSupport,
  changeLog,
}

/// The enum for the bottom navigation bar
enum EnumBottonBarItem {
  home,
  exchange,
  trade,
  balance,
}

/// The enum for the exchage screen top section
enum EnumExchangeFilter {
  dex,
  btc,
  dot,
  altCoins,
  fiat,
}

/// The enum class app settings notification screen
enum EnumNotificationsMenu {
  withdraw,
  deposit,
  filledOrder,
}

/// The enum class for menu for notifications
enum EnumNotificationAlert {
  email,
  phone,
  push,
}

/// Enum class for buy sell filter
enum EnumBuySellAll {
  buy,
  all,
  sell,
}

enum EnumBuySell {
  buy,
  sell,
}

/// Enum for market limit drop down popups
enum EnumOrderTypes {
  market,
  limit,
  stop,
}

/// Enum for market limit drop down popups
enum EnumTradeTypes {
  withdraw,
  deposit,
}

enum EnumAppChartTimestampTypes {
  oneMinute,
  fiveMinutes,
  thirtyMinutes,
  oneHour,
  fourHours,
  twelveHours,
  oneDay,
  oneWeek,
  oneMonth,
}

enum EnumAppChartDataTypes {
  average,
  high,
  low,
}

enum EnumBalanceChartDataTypes {
  hour,
  week,
  month,
  threeMonth,
  sixMonth,
  year,
  all,
}

enum EnumDrawerNotificationTypes {
  transactionDeposit,
  transactionWithdraw,
  normal,
}

enum EnumAmountType {
  btc,
  usd,
}

enum EnumTradeOrdersDisplayType {
  open,
  history,
}

enum EnumDepositScreenTypes {
  withdraw,
  deposit,
}

enum EnumMarketDropdownTypes {
  orderbook,
  depthmarket,
}

enum EnumTimerIntervalTypes {
  oneMinute,
  twoMinutes,
  threeMinutes,
  fiveMinutes,
  tenMinutes,
  thirtyMinutes,
}

enum EnumTradeBottomDisplayTypes {
  openOrders,
  orderHistory,
  tradeHistory,
}
