extends Node

onready var MintageScene := preload("res://scenes/Mintage.tscn")

enum MintageState { RAW_METAL, MOLTEN_METAL, WET_PLANCHET, PLANCHET, COIN }

# Amount of work required to make a mintage change to its next state.
const WORK_FOR_NEXT_STATE := 1.0

# Machine condition will decay this amount per second
const MACHINE_DECAY_RATE := 1.0 / 100

# Stats will be kept for tis many seconds. Should be a number
# that divides 60 without a remainder.
const COIN_RATE_STATS_SIZE := 15

# Will initialize the game in a state as if we were having this coin rate
const INITIAL_COINS_PER_SEC := 1

var gameState: GameState = null
var player: Player = null


func _ready() -> void:
	randomize()


func initGameState() -> void:
	gameState = GameState.new()


func makeMintage(state: int, pos: Vector2) -> Node:
	var m := MintageScene.instance()
	m.state = state
	Globals.gameState.stocks[state] += 1
	m.updateSprite()
	m.workForNextState = WORK_FOR_NEXT_STATE
	m.position = pos
	return m


func updateStatsAfterCoinLeft() -> void:
	for i in range(COIN_RATE_STATS_SIZE):
		gameState.coinsPerSecStats[i] += 1
