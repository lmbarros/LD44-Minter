extends Node2D
class_name Mintage

var state: int = Globals.MintageState.RAW_METAL

# How much this must be worked to get to the next state
var workForNextState: float = Globals.WORK_FOR_NEXT_STATE

# Do a given amount of work on this "coinage thing" so that it eventually gets
# to its next state. Returns a Boolean indicating if the mintage changed its
# state.
func work(amount: float) -> bool:
	# Already a coin, there is no next state
	if state == Globals.MintageState.COIN:
		return false

	workForNextState -= amount
	if workForNextState <= 0:
		turnIntoNextState()
		return true

	return false


func turnIntoNextState() -> void:
	var newState := state + 1
	Globals.gameState.stocks[state] -= 1
	Globals.gameState.stocks[newState] += 1
	state = newState
	workForNextState = Globals.WORK_FOR_NEXT_STATE
	updateSprite()


func updateSprite():
	match state:
		Globals.MintageState.RAW_METAL:
			$Sprite.texture = load("res://gfx/raw-metal.png")
		Globals.MintageState.MOLTEN_METAL:
			$Sprite.texture = load("res://gfx/molten-metal.png")
		Globals.MintageState.WET_PLANCHET:
			$Sprite.texture = load("res://gfx/wet-planchet.png")
		Globals.MintageState.PLANCHET:
			$Sprite.texture = load("res://gfx/planchet.png")
		Globals.MintageState.COIN:
			$Sprite.texture = load("res://gfx/coin.png")


func moveTo(target: Vector2) -> void:
	var tweenDuration := 1.0
	$MoveTween.interpolate_property(self, "position", position, target, tweenDuration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$MoveTween.start()
