extends Node

onready var MintageScene := preload("res://scenes/Mintage.tscn")

enum MintageState { RAW_METAL, MOLTEN_METAL, WET_PLANCHET, PLANCHET, COIN }

# Amount of work required to make a mintage change to its next state.
const WORK_FOR_NEXT_STATE := 0.75

# Machine condition will decay this amount per second
const MACHINE_DECAY_RATE := 1.0 / 120

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


# This is called once per second, from GameUI (oh, my)
func generateRandomEventMaybe(deltaInSecs: float) -> void:
	gameState.secsOfGame += deltaInSecs
	gameState.secsWithoutRandomEvents += deltaInSecs
	
	var interval := 0.0

	if gameState.secsOfGame > 720:
		interval = 5
	elif gameState.secsOfGame > 360:
		interval = 10
	elif gameState.secsOfGame > 180:
		interval = 15
	elif gameState.secsOfGame > 90:
		interval = 20
	elif gameState.secsOfGame > 60:
		interval = 25
	else:
		interval = 30
		
	var prob := 0.1 + (gameState.secsWithoutRandomEvents / 60.0)
		
	if gameState.secsWithoutRandomEvents > interval:
		var r := randf()
		if r < prob:
			# Time to generate a random event!
			gameState.secsWithoutRandomEvents = 0.0
			r = randf()
			if r < 0.5:
				generateBrokenMachineEvent()
			else:
				generateThiefEvent()


func generateBrokenMachineEvent() -> void:
	SoundManager.breaking()
	var machine = Globals.gameState.machines[randi() % 4] as Machine
	machine.suddenBreak()
	showToast("Your %s just had a failure!" % machine.machineName)


onready var ThiefScene := preload("res://characters/Thief.tscn")
func generateThiefEvent() -> void:
	SoundManager.visitor()
	var thief := ThiefScene.instance()
	thief.position = getPointInGroup("ThiefSpawnPoints")
	gameScene.add_child(thief)
	showToast("A thief invaded the mint!")


onready var _toastFont = preload("res://fonts/toast-font.tres")
func showToast(text: String) -> void:
	var parent := gameScene.find_node("Toasts")
	var tween := parent.find_node("Tween")
	var label := Label.new()
	label.align = Label.ALIGN_CENTER
	label.add_font_override("font", _toastFont)
	label.text = text
	label.rect_position = Vector2(0, 720)
	label.rect_size = Vector2(1000, 80)
	parent.add_child(label)

	tween.interpolate_property(label, "rect_position", label.rect_position,
		Vector2(0, 550), 5.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(label, "modulate", label.modulate,
		Color(1.0, 1.0, 1.0, 0.0), 5.0, Tween.TRANS_QUAD, Tween.EASE_OUT)

	tween.start()

	yield(get_tree().create_timer(5.0), "timeout")
	if is_instance_valid(parent):
		parent.remove_child(label)


func getPointInGroup(group: String) -> Vector2:
	var points := get_tree().get_nodes_in_group(group)
	return points[randi() % points.size()].position
