extends Node
class_name GameState

# The score is the number of coins delivered
var score: int = 0

# Stocks, indexed by the Globals.MintageState
var stocks: Array = [ 0, 0, 0, 0, 0 ]

# The machines, indexed by the Globals.MintageState they work on
var machines: Array = [ ]

# Entries for the previous Globals.COIN_RATE_STATS_SIZE seconds. New data pushed
# to the back and popped from the front every second. All of them incremented
# when a coin leaves successfully the mint.
var coinsPerSecStats: Array = [ ]

# The current coin rate
var coinsPerSec := 0

# Can be bonuses or penalties. Dictionaries with these fields:
#    descr: string
#    secsRemaining: float
#    amount: int
var coinRateModifiers: Array = [ ]


var secsOfGame := 0.0
var secsWithoutRandomEvents := 0.0


func _init():
	for _i in range(Globals.COIN_RATE_STATS_SIZE):
		coinsPerSecStats.push_back(
			Globals.INITIAL_COINS_PER_SEC * Globals.COIN_RATE_STATS_SIZE)
