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
var gameScene: Node = null


var helpText: String = ""

func _ready() -> void:
	randomize()


func initGameState() -> void:
	gameState = GameState.new()


func makeMintage(state: int, pos: Vector2) -> Node:
	var m := MintageScene.instance()
	m.state = state
	gameState.stocks[state] += 1
	m.updateSprite()
	m.workForNextState = WORK_FOR_NEXT_STATE
	m.position = pos
	return m


func updateStatsAfterCoinLeft() -> void:
	for i in range(COIN_RATE_STATS_SIZE):
		gameState.coinsPerSecStats[i] += 1


func addCoinRateModifier(descr: String, durationInSecs: float, amount: int) -> void:
	gameState.coinRateModifiers.append({
		descr = descr,
		secsRemaining = durationInSecs,
		amount = amount,
	})


func updateCoinRateModifiers(deltaInSecs: float) -> void:
	var toRemove := [ ]

	var mods := gameState.coinRateModifiers
	for i in mods.size():
		mods[i].secsRemaining -= deltaInSecs
		if mods[i].secsRemaining <= 0:
			toRemove.push_front(i) # reverse order, to make removal easier

	for i in toRemove:
		mods.remove(i)


func getCurrentCoinRateModifier() -> int:
	var modifier := 0
	for m in gameState.coinRateModifiers:
		modifier += m.amount
	return modifier


onready var _toastFont = preload("res://fonts/toast-font.tres")
func showToast(text: String) -> void:
	var parent := gameScene.find_node("Toasts")
	var tween := parent.find_node("Tween")
	var label := Label.new()
	label.align = Label.ALIGN_CENTER
	label.add_font_override("font", _toastFont)
	label.text = text
	label.rect_position = Vector2(0, 780)
	label.rect_size = Vector2(1000, 80)
	parent.add_child(label)

	tween.interpolate_property(label, "rect_position", label.rect_position,
		Vector2(0, 550), 5.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(label, "modulate", label.modulate,
		Color(1.0, 1.0, 1.0, 0.0), 5.0, Tween.TRANS_QUAD, Tween.EASE_OUT)

	tween.start()

	yield(get_tree().create_timer(5.0), "timeout")
	parent.remove_child(label)
