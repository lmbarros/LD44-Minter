extends Node2D

var state: int = Globals.MintageState.RAW_METAL

# How much this must be worked to get to the next state
var workForNextState: float = Globals.WORK_FOR_NEXT_STATE

# Do a given amount of work on this "coinage thing" so that it eventually gets
# to its next state.
func work(amount: float) -> void:
	# Alrady a coin, there is no next state
	if state == Globals.MintageState.COIN:
		return

	workForNextState -= amount
	if workForNextState >= 0:
		match state:
			Globals.MintageState.RAW_METAL:
				turnIntoMoltenMetal()
			Globals.MintageState.MOLTEN_METAL:
				turnIntoWetPlanchet()
			Globals.MintageState.WET_PLANCHET:
				turnIntoPlanchet()
			Globals.MintageState.PLANCHET:
				turnIntoCoin()


func turnIntoMoltenMetal() -> void:
	state = Globals.MintageState.MOLTEN_METAL
	workForNextState = Globals.WORK_FOR_NEXT_STATE
	updateSprite()

	
func turnIntoWetPlanchet() -> void:
	state = Globals.MintageState.WET_PLANCHET
	workForNextState = Globals.WORK_FOR_NEXT_STATE
	updateSprite()


func turnIntoPlanchet() -> void:
	state = Globals.MintageState.PLANCHET
	workForNextState = Globals.WORK_FOR_NEXT_STATE
	updateSprite()


func turnIntoCoin() -> void:
	state = Globals.MintageState.COIN
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
