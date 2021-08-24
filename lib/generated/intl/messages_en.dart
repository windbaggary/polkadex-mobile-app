// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(coin) => "Amount (${coin})";

  static String m1(number) => "DOT Chain ${number}";

  static String m2(discountPercent) =>
      "Enjoy ${discountPercent}% discount when trading.";

  static String m3(prizeAmount) =>
      "Participate in lucky draw and share ${prizeAmount} USDT prize poll!";

  static String m4(coin) => "Price (${coin})";

  static String m5(volume) => "Vol ${volume} BTC";

  static String m6(amountBought, amountGiven, dateTime) =>
      "You bought ${amountBought} DEX for ${amountGiven} BTC at ${dateTime}";

  static String m7(amount, dateTime) =>
      "You have deposited ${amount} LTC at ${dateTime}";

  static String m8(amountSold, amountReceived, dateTime) =>
      "You have sold ${amountSold} BTC for ${amountReceived} DEX at ${dateTime}";

  static String m9(amountWithdraw, dateTime) =>
      "You have withdraw ${amountWithdraw} LTC at ${dateTime}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aFullyDecentralized": MessageLookupByLibrary.simpleMessage(
            "A fully decentralized, peer-peer, orderbook based cryptocurrency exchange"),
        "aLimitOrderIsAnOrder": MessageLookupByLibrary.simpleMessage(
            "A limit order is an order to buy or sell a stock with a restriction on the maximum price to be paid or the minimum price to be received."),
        "aMarketOrderIsAnOrder": MessageLookupByLibrary.simpleMessage(
            "A market order is an order to buy or sell a stock at the market’s current best available price."),
        "aStopOrderIsAnOrder": MessageLookupByLibrary.simpleMessage(
            "A stop order is an order to buy or sell a stock at the market price once the stock has traded at or through a specified price."),
        "aboutPolkadex": MessageLookupByLibrary.simpleMessage("About Polkadex"),
        "accountName": MessageLookupByLibrary.simpleMessage("Account Name"),
        "addAWalletByImporting": MessageLookupByLibrary.simpleMessage(
            "Add a wallet by importing recovery phase"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allMarkets": MessageLookupByLibrary.simpleMessage("All Markets"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "amountCoin": m0,
        "anyProblemWithThis": MessageLookupByLibrary.simpleMessage(
            "Any problem with this transaction?"),
        "appInformation":
            MessageLookupByLibrary.simpleMessage("App Information"),
        "appSettings": MessageLookupByLibrary.simpleMessage("App Settings"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "atLeast1Digit":
            MessageLookupByLibrary.simpleMessage("At least 1 digit"),
        "atLeast1Lowercase":
            MessageLookupByLibrary.simpleMessage("At least 1 lowercase"),
        "atLeast1Uppercase":
            MessageLookupByLibrary.simpleMessage("At least 1 uppercase letter"),
        "atLeast8Characters":
            MessageLookupByLibrary.simpleMessage("At least 8 characters"),
        "attentionSendingToken": MessageLookupByLibrary.simpleMessage(
            "Attention: Sending token other than DEX to this address may result in the loss of your deposit."),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "availableImportWallet": MessageLookupByLibrary.simpleMessage(
            "Available import wallet methods"),
        "backupMnemonicPhrases":
            MessageLookupByLibrary.simpleMessage("Backup mnemonic phrases"),
        "barrier": MessageLookupByLibrary.simpleMessage("Barrier"),
        "blockAccess": MessageLookupByLibrary.simpleMessage(
            "Block access to suspicious IPs."),
        "btcMarket": MessageLookupByLibrary.simpleMessage("BTC Market"),
        "buy": MessageLookupByLibrary.simpleMessage("Buy"),
        "buyDot": MessageLookupByLibrary.simpleMessage("Buy DOT"),
        "byContinuingIAllow": MessageLookupByLibrary.simpleMessage(
            "By continuing, I allow Polkadex App to collect data on how I use the app, which will be used to improve the Polkadex App. For more details. refer to our "),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "chain": MessageLookupByLibrary.simpleMessage("Chain"),
        "change": MessageLookupByLibrary.simpleMessage("Change"),
        "changelog": MessageLookupByLibrary.simpleMessage("Changelog"),
        "changingTheLanguage":
            MessageLookupByLibrary.simpleMessage("Changing the language..."),
        "chooseALanguage":
            MessageLookupByLibrary.simpleMessage("Choose a language"),
        "circulationSupply":
            MessageLookupByLibrary.simpleMessage("Circulation Supply"),
        "coinInfo": MessageLookupByLibrary.simpleMessage("Coin Info"),
        "commonQuestionsAnd": MessageLookupByLibrary.simpleMessage(
            "Common questions and support docs"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "connectLedgerDeviceFor": MessageLookupByLibrary.simpleMessage(
            "Connect ledger device for import your wallet"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "createAnAccount":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "createWallet": MessageLookupByLibrary.simpleMessage("Create Wallet"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "currentTradingFee":
            MessageLookupByLibrary.simpleMessage("Current trading fee"),
        "date": MessageLookupByLibrary.simpleMessage("date"),
        "deepMarket": MessageLookupByLibrary.simpleMessage("Deep Market"),
        "deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
        "depositPolkadex": MessageLookupByLibrary.simpleMessage("Deposit PDEX"),
        "depositSuccessful":
            MessageLookupByLibrary.simpleMessage("Deposit Successful"),
        "deviceID": MessageLookupByLibrary.simpleMessage("Device ID"),
        "dexBtcFilledSuccessful":
            MessageLookupByLibrary.simpleMessage("DEX/BTC Filled Successful"),
        "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
        "discord": MessageLookupByLibrary.simpleMessage("Discord"),
        "dotChain": m1,
        "earnWithUpcomingDeFi": MessageLookupByLibrary.simpleMessage(
            "Earn with upcoming DeFi airdrops"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enjoyDiscountWhen": m2,
        "enter": MessageLookupByLibrary.simpleMessage("Enter"),
        "enterAmount": MessageLookupByLibrary.simpleMessage("Enter Amount"),
        "enterDexAddress":
            MessageLookupByLibrary.simpleMessage("Enter Dex address"),
        "event": MessageLookupByLibrary.simpleMessage("EVENT"),
        "filledOrder": MessageLookupByLibrary.simpleMessage("Filled Order"),
        "frequentlyAsked":
            MessageLookupByLibrary.simpleMessage("Frequently Asked Questions"),
        "from": MessageLookupByLibrary.simpleMessage("From"),
        "gainers": MessageLookupByLibrary.simpleMessage("Gainers"),
        "generateWallet":
            MessageLookupByLibrary.simpleMessage("Generate Wallet"),
        "getInTouch":
            MessageLookupByLibrary.simpleMessage("Get in touch with us"),
        "haveBeenMade": MessageLookupByLibrary.simpleMessage(
            "have been made to the User Center interface to make it more intuitive"),
        "helpAndSupport":
            MessageLookupByLibrary.simpleMessage("Help & Support"),
        "helpMakePolkadex":
            MessageLookupByLibrary.simpleMessage("Help make Polkadex Better"),
        "hideSmallBalances":
            MessageLookupByLibrary.simpleMessage("Hide small balances"),
        "high": MessageLookupByLibrary.simpleMessage("HIGH"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "holding": MessageLookupByLibrary.simpleMessage("Holding"),
        "hour24": MessageLookupByLibrary.simpleMessage("24 hour"),
        "iHaveSavedMyMnemonic": MessageLookupByLibrary.simpleMessage(
            "I have saved my mnemonic seed safely."),
        "ifYouFindAnyLink": MessageLookupByLibrary.simpleMessage(
            "If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.\n\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date."),
        "importWallet": MessageLookupByLibrary.simpleMessage("Import Wallet"),
        "importWalletFromBackup": MessageLookupByLibrary.simpleMessage(
            "Import wallet from backup JSON file"),
        "inFiat": MessageLookupByLibrary.simpleMessage("In Fiat"),
        "incorrectMnemonicPhrase":
            MessageLookupByLibrary.simpleMessage("Incorrect mnemonic phrase"),
        "interface": MessageLookupByLibrary.simpleMessage("Interface"),
        "jsonFile": MessageLookupByLibrary.simpleMessage("Json File"),
        "languageAndCurrency":
            MessageLookupByLibrary.simpleMessage("Language & Currency"),
        "lastUpdated": MessageLookupByLibrary.simpleMessage("Last Updated"),
        "latestTransaction":
            MessageLookupByLibrary.simpleMessage("Latest transaction"),
        "leaveUsFeedback":
            MessageLookupByLibrary.simpleMessage("Leave us feedback"),
        "ledgerDevice": MessageLookupByLibrary.simpleMessage("Ledger Device"),
        "license": MessageLookupByLibrary.simpleMessage("License"),
        "limit": MessageLookupByLibrary.simpleMessage("Limit"),
        "limitOrder": MessageLookupByLibrary.simpleMessage("Limit Order"),
        "links": MessageLookupByLibrary.simpleMessage("Links"),
        "losers": MessageLookupByLibrary.simpleMessage("Losers"),
        "low": MessageLookupByLibrary.simpleMessage("LOW"),
        "ltcMarket": MessageLookupByLibrary.simpleMessage("LTC Market"),
        "mainWallet": MessageLookupByLibrary.simpleMessage("Main Wallet"),
        "margin": MessageLookupByLibrary.simpleMessage("Margin"),
        "market": MessageLookupByLibrary.simpleMessage("Market"),
        "marketOrder": MessageLookupByLibrary.simpleMessage("Market Order"),
        "marketPrice": MessageLookupByLibrary.simpleMessage("Market Price"),
        "marketStats": MessageLookupByLibrary.simpleMessage("market stats"),
        "marketcap": MessageLookupByLibrary.simpleMessage("Marketcap"),
        "markets": MessageLookupByLibrary.simpleMessage("Markets"),
        "maxSupply": MessageLookupByLibrary.simpleMessage("Max Supply"),
        "mnemonicPhrase":
            MessageLookupByLibrary.simpleMessage("Mnemonic Phrase"),
        "month1": MessageLookupByLibrary.simpleMessage("1 month"),
        "moreDetails": MessageLookupByLibrary.simpleMessage("More Details"),
        "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
        "network": MessageLookupByLibrary.simpleMessage("Network"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "notificationDetails":
            MessageLookupByLibrary.simpleMessage("Notifications Details"),
        "notificationSettings":
            MessageLookupByLibrary.simpleMessage("Notification Settings"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationsCenter":
            MessageLookupByLibrary.simpleMessage("Notifications Center"),
        "notifyWhenAFunds": MessageLookupByLibrary.simpleMessage(
            "Notify when a funds are received."),
        "notifyWhenAWithdrawal": MessageLookupByLibrary.simpleMessage(
            "Notify when a withdrawal is requested."),
        "notifyWhenAnOrder": MessageLookupByLibrary.simpleMessage(
            "Notify when an order is filled."),
        "oneOrMoreOfYour1224Words": MessageLookupByLibrary.simpleMessage(
            "One or more of your 12-24 words are incorrect, make sure that the order is correct or if there is a typing error."),
        "online": MessageLookupByLibrary.simpleMessage("Online"),
        "openOrders": MessageLookupByLibrary.simpleMessage("Open Orders"),
        "optimize": MessageLookupByLibrary.simpleMessage("Optimize"),
        "orderBook": MessageLookupByLibrary.simpleMessage("Order Book"),
        "orderTypes": MessageLookupByLibrary.simpleMessage("Order Types"),
        "ordersHistory": MessageLookupByLibrary.simpleMessage("Orders History"),
        "others": MessageLookupByLibrary.simpleMessage("Others"),
        "pair": MessageLookupByLibrary.simpleMessage("Pair"),
        "participateInLuckyDraw": m3,
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "pleaseEnterAValidPrice":
            MessageLookupByLibrary.simpleMessage("Please enter a valid price"),
        "pleaseEnterAgain":
            MessageLookupByLibrary.simpleMessage("Please enter again."),
        "pleaseEnterThe1224Words": MessageLookupByLibrary.simpleMessage(
            "Please rearrange the 12-24 words in the correct order."),
        "pleaseEnterThePrice":
            MessageLookupByLibrary.simpleMessage("Please enter the price"),
        "pleaseWriteDownYour": MessageLookupByLibrary.simpleMessage(
            "Please write down your wallet’s mnemonic seed and keep it in a safe place."),
        "polkadexDexAddress":
            MessageLookupByLibrary.simpleMessage("Polkadex DEX Address"),
        "polkadexExchangeAppDoesNot": MessageLookupByLibrary.simpleMessage(
            "Polkadex Exchange eApp does not keep it, if you forget the password, you cannot restore it."),
        "polkadexIfYouUninstall": MessageLookupByLibrary.simpleMessage(
            "Polkadex does not store any data , this is just a temporary data, if you uninstall the Polkadex App your name and referral ID will be removed."),
        "polkadexInterfaceTour":
            MessageLookupByLibrary.simpleMessage("Polkadex interface tour"),
        "polkadexLanguage":
            MessageLookupByLibrary.simpleMessage("Polkadex Language"),
        "polkadexOnlyEnable": MessageLookupByLibrary.simpleMessage(
            "Polkadex does not store any data , by security, Polkadex only enable withdrawals by confirmation via Two-Factor Authentication (2FA)."),
        "polkadexStatus":
            MessageLookupByLibrary.simpleMessage("Polkadex Status"),
        "polkadexSystemMessage":
            MessageLookupByLibrary.simpleMessage("Polkadex system message"),
        "previous": MessageLookupByLibrary.simpleMessage("Previous"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "priceCoin": m4,
        "priceShouldBeGreater": MessageLookupByLibrary.simpleMessage(
            "Price should be greater than 0.00"),
        "priceShouldBeLess": MessageLookupByLibrary.simpleMessage(
            "Price should be less than wallet balance"),
        "pricingLength": MessageLookupByLibrary.simpleMessage("Pricing Length"),
        "privacyAndSecurity":
            MessageLookupByLibrary.simpleMessage("Privacy & Security"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "purchaseAddedToOpen": MessageLookupByLibrary.simpleMessage(
            "Purchase added to open orders"),
        "push": MessageLookupByLibrary.simpleMessage("Push"),
        "rank": MessageLookupByLibrary.simpleMessage("Rank"),
        "rankingList": MessageLookupByLibrary.simpleMessage("Ranking List"),
        "recent": MessageLookupByLibrary.simpleMessage("Recent"),
        "reddit": MessageLookupByLibrary.simpleMessage("Reddit"),
        "referral": MessageLookupByLibrary.simpleMessage("Referral"),
        "removalOfLinksFrom": MessageLookupByLibrary.simpleMessage(
            "Removal of links from our website"),
        "repeatPassword":
            MessageLookupByLibrary.simpleMessage("Repeat Password"),
        "repeatYourPassword":
            MessageLookupByLibrary.simpleMessage("Repeat your password"),
        "reservationOfRights":
            MessageLookupByLibrary.simpleMessage("Reservation of Rights"),
        "restoreExistingWallet":
            MessageLookupByLibrary.simpleMessage("Restore existing wallet"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "scanOrShare": MessageLookupByLibrary.simpleMessage("Scan or share"),
        "searchNameOrTicket":
            MessageLookupByLibrary.simpleMessage("Search name or ticket"),
        "secureWithBiometric":
            MessageLookupByLibrary.simpleMessage("Secure with Biometric login"),
        "secureWithPinCode":
            MessageLookupByLibrary.simpleMessage("Secure with Pin Code"),
        "secureYourAccessWithout": MessageLookupByLibrary.simpleMessage(
            "Secure your access without typing your Pin Code."),
        "securityPasswordIsUsedFor": MessageLookupByLibrary.simpleMessage(
            "Security password is used for transfers, create orders, mnemonics backups, applications authorization, etc."),
        "seeTheTokenPriceLike":
            MessageLookupByLibrary.simpleMessage("See the token price like:"),
        "selectTheLanguageYouWould": MessageLookupByLibrary.simpleMessage(
            "Select the language you would like to use while running Polkadex Mobile App"),
        "sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "sellDot": MessageLookupByLibrary.simpleMessage("Sell DOT"),
        "setPassword": MessageLookupByLibrary.simpleMessage("Set password"),
        "setWalletName":
            MessageLookupByLibrary.simpleMessage("Set wallet name"),
        "share": MessageLookupByLibrary.simpleMessage("share"),
        "slideToWithdraw":
            MessageLookupByLibrary.simpleMessage("Slide to withdraw"),
        "someMajorUpdates":
            MessageLookupByLibrary.simpleMessage("Some major updates"),
        "spot": MessageLookupByLibrary.simpleMessage("Spot"),
        "startTour": MessageLookupByLibrary.simpleMessage("Start Tour"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "stop": MessageLookupByLibrary.simpleMessage("Stop"),
        "stopOrder": MessageLookupByLibrary.simpleMessage("Stop Order"),
        "styleSettings": MessageLookupByLibrary.simpleMessage("Style Settings"),
        "suggestions": MessageLookupByLibrary.simpleMessage("Suggestions"),
        "summary": MessageLookupByLibrary.simpleMessage("Summary"),
        "supportCenter": MessageLookupByLibrary.simpleMessage("Support Center"),
        "tap": MessageLookupByLibrary.simpleMessage("Tap"),
        "telegram": MessageLookupByLibrary.simpleMessage("Telegram"),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "theAddressIsCopied": MessageLookupByLibrary.simpleMessage(
            "The address is copied to the clipboard"),
        "theFunctionOf": MessageLookupByLibrary.simpleMessage(
            "the function of creating alerts"),
        "theLimitationsAndProhibitions": MessageLookupByLibrary.simpleMessage(
            "The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.\n\nTo the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:"),
        "theMnemonicCanBeUsedTo": MessageLookupByLibrary.simpleMessage(
            "The mnemonic can be used to restore your wallet. Keep it carefully to not lose your assets. Having the mnemonic phrases can have a full control over the assets."),
        "theReferralId": MessageLookupByLibrary.simpleMessage(
            "The referral id is copied to the clipboard"),
        "theTransactionIdIsCopied": MessageLookupByLibrary.simpleMessage(
            "The transaction id is copied to the clipboard"),
        "theUserInterface": MessageLookupByLibrary.simpleMessage(
            "the user interface of balance"),
        "thereAreNoTransactions":
            MessageLookupByLibrary.simpleMessage("There are no transactions"),
        "theseTermsAndConditionsOutline": MessageLookupByLibrary.simpleMessage(
            "These terms and conditions outline the rules and regulations for the use of Polkadex’s Website, located at https:://polkadex.trade.\n\nBy accessing this website we assume you accept these terms and conditions. Do not continue to use Polkadex.trade if you do not agree to take all of the terms and conditions stated on this page.\n\nThe following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company’s terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same."),
        "timezone": MessageLookupByLibrary.simpleMessage("Timezone"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "toCopy": MessageLookupByLibrary.simpleMessage("to copy"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "token": MessageLookupByLibrary.simpleMessage("Token"),
        "tokens": MessageLookupByLibrary.simpleMessage("Tokens"),
        "topsPairs": MessageLookupByLibrary.simpleMessage("Tops Pairs"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "trackingIp": MessageLookupByLibrary.simpleMessage("Tracking IP"),
        "trade": MessageLookupByLibrary.simpleMessage("Trade"),
        "trade1": MessageLookupByLibrary.simpleMessage("Trade 1"),
        "trade3": MessageLookupByLibrary.simpleMessage("Trade 3"),
        "tradePairs": MessageLookupByLibrary.simpleMessage("Trade Pairs"),
        "trading": MessageLookupByLibrary.simpleMessage("Trading"),
        "transaction": MessageLookupByLibrary.simpleMessage("Transaction"),
        "transactionFee":
            MessageLookupByLibrary.simpleMessage("Transaction Fee"),
        "transactionID": MessageLookupByLibrary.simpleMessage("Transaction ID"),
        "twitter": MessageLookupByLibrary.simpleMessage("Twitter"),
        "twoFactorAuth": MessageLookupByLibrary.simpleMessage(
            "Two-Factor Authentication (2FA)"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "typeYourSecretMnemonicSeed": MessageLookupByLibrary.simpleMessage(
            "Type your secret phrase to restore your existing wallet 12-24 words mnemonic seed."),
        "typeYourSecretPhrase": MessageLookupByLibrary.simpleMessage(
            "Type your secret phrase to restore your existing wallet."),
        "unlessOtherwiseStatedPolkadex": MessageLookupByLibrary.simpleMessage(
            "Unless otherwise stated, Polkadex and/or its licensors own the intellectual property rights for all material on Polkadex.trade. All intellectual property rights are reserved. You may access this from Polkadex.trade for your own personal use subjected to restrictions set in these terms and conditions.\n\nThis Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator and the Privacy Policy Generator.\n\nParts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Polkadex does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Polkadex,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Polkadex shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.\n\nPolkadex reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions."),
        "usd": MessageLookupByLibrary.simpleMessage("USD"),
        "useDEXtoPayFees":
            MessageLookupByLibrary.simpleMessage("Use DEX to pay fees"),
        "useDevice":
            MessageLookupByLibrary.simpleMessage("Use Device Settings"),
        "useTheGoogleAuth": MessageLookupByLibrary.simpleMessage(
            "Use the Google Authentication or Authy app to generate one time security codes."),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "versionUpdate": MessageLookupByLibrary.simpleMessage("Version Update"),
        "viewMoreDetaisAtTokenview": MessageLookupByLibrary.simpleMessage(
            "View more details at Tokenview"),
        "vol": MessageLookupByLibrary.simpleMessage("Vol"),
        "vol24h": MessageLookupByLibrary.simpleMessage("VOL(24h)"),
        "volBTC": m5,
        "walletName": MessageLookupByLibrary.simpleMessage("Wallet Name"),
        "walletSettings":
            MessageLookupByLibrary.simpleMessage("Wallet Settings"),
        "weAdded": MessageLookupByLibrary.simpleMessage("We added"),
        "weAreAlmostThere":
            MessageLookupByLibrary.simpleMessage("We are almost there..."),
        "weFixed": MessageLookupByLibrary.simpleMessage("We Fixed"),
        "weIntroducePolkadexFSP": MessageLookupByLibrary.simpleMessage(
            "We introduce Polkadex’s FSP (Fluid Switch Protocol). Polkadex is a hybrid DEX with an orderbook supported by an AMM pool. The first of its kind in the industry. Someone had to innovate. We are happy to do the dirty work. It may not be perfect, but we are sure that once implemented, it can solve the problem faced by DEXs paving the way for near-boundless liquidity and high guarantee of trades if supported by an efficient trading engine. The trading engine itself needs a separate look and it is a whole dedicated project in itself; hence it is covered in another medium article. Let’s stick to the core protocol here."),
        "weReserveTheRightTo": MessageLookupByLibrary.simpleMessage(
            "We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions."),
        "weSpendALot": MessageLookupByLibrary.simpleMessage(
            "We spend a lot of time working on big features. This time we set time aside to tackle small changes as we cleaning, shining and polishing Polkadex:"),
        "website": MessageLookupByLibrary.simpleMessage("Website"),
        "week1": MessageLookupByLibrary.simpleMessage("1 week"),
        "welcomeToPolkadexTrade":
            MessageLookupByLibrary.simpleMessage("Welcome to Polkadex.trade!"),
        "whatsNew":
            MessageLookupByLibrary.simpleMessage("What’s new in Polkadex"),
        "whileDeFiIsInItsVery": MessageLookupByLibrary.simpleMessage(
            "While DeFi is in its very early days, there are a number of ways in which investors can earn passive income. The entire reason for the existence of such platforms and products is to deliver liquidity to the DeFi space through incentivization."),
        "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
        "withdrawFee": MessageLookupByLibrary.simpleMessage("Withdraw Fee"),
        "withdrawPolkadex":
            MessageLookupByLibrary.simpleMessage("Withdraw PDEX"),
        "withdrawSuccessful":
            MessageLookupByLibrary.simpleMessage("Withdraw Successful"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
        "youHaveBought": m6,
        "youHaveDeposited": m7,
        "youHaveSold": m8,
        "youHaveWithdraw": m9,
        "yourAccessAreKept": MessageLookupByLibrary.simpleMessage(
            "Your access are kept safe by Pin Code."),
        "yourDexAddres":
            MessageLookupByLibrary.simpleMessage("Your DEX Address")
      };
}
