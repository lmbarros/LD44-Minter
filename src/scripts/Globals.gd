extends Node

onready var MintageScene := preload("res://scenes/Mintage.tscn")

enum MintageState { RAW_METAL, MOLTEN_METAL, WET_PLANCHET, PLANCHET, COIN }

# Amount of work required to make a mintage change to its next state.
const WORK_FOR_NEXT_STATE := 1.0


var gameState: GameState = null


func _ready() -> void:
	randomize()


func initGameState() -> void:
	gameState = GameState.new()


func makeMintage(state: int, pos: Vector2, wfns: float = WORK_FOR_NEXT_STATE) -> Node:
	var m := MintageScene.instance()
	m.state = state
	Globals.gameState.stocks[state] += 1
	m.updateSprite()
	m.workForNextState = wfns
	m.position = pos
	return m
