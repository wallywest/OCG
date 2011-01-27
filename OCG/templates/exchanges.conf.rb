#EXCHANGE INFO FOR EXCHANGEHUB.EXCHANGE.CONF

#TOTAL COUNT
#NumberOfExchanges

############################################################

CMEDEMO="
Exchange1 = CLASS:com.optionscity.exchanges_CME.CMEDemo
ExchangeConf1 = conf/CME.conf
Exchange1IsQuoting = false
Exchange1IsDefaultMDProvider = true
Exchange1StartTime = add 00 02 00"

CME="Exchange1 = CLASS:com.optionscity.exchanges_CME.CME
ExchangeConf1 = conf/CME.conf
Exchange1IsDefaultMDProvider = true
Exchange1StartTime = add 00 01 00"

CBOE="Exchange2 = CLASS:com.optionscity.exchanges_CBOE.CBOE
ExchangeConf2 = conf/CBOE.conf
Exchange2IsDefaultMDProvider = false
#Exchange2StartTime = add 00 01 30
Exchange2StartTime = at 06 45 00"

NULL="Exchange3 = CLASS:com.optionscity.exchanges_null.NullExchange
ExchangeConf3 = null
Exchange3IsDefaultMDProvider = false
Exchange3StartTime = add 00 01 30"

REDI="Exchange4 = CLASS:com.optionscity.exchanges_REDI.REDI
ExchangeConf4 = conf/REDI.conf
Exchange4IsQuoting = false
Exchange4IsDefaultMDProvider = false
Exchange4StartTime = add 00 01 00"

ICE="Exchange1 = CLASS:com.optionscity.exchanges_ICE.ICE
ExchangeConf1 = conf/ICE.conf
Exchange1IsDefaultMDProvider = true
Exchange1StartTime = add 00 01 00"

CFE="Exchange3 = CLASS:com.optionscity.exchanges_CBOE.CBSX
ExchangeConf3 = conf/CBSX.conf
Exchange3IsDefaultMDProvider = false
#Exchange3StartTime = add 00 02 50
Exchange3StartTime = at 06 47 00"

###############################################################
#MARKET DATA PROVIDERS
#NumberOfMDProviders = 1

ACTIV="MarketDataProvider1 = CLASS:com.optionscity.exchanges_activ.Activ
MarketDataProviderConf1 = conf/ACTIV.conf
MarketDataProvider1IsDefaultMDProvider = false
MarketDataProvider1StartTime = add 00 01 02"

###############################################################
#DO SUBSCRIPTONS LATER
