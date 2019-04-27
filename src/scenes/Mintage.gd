extends Node2D

enum State { RAW_METAL, MOLTEN_METAL, WET_PLANCHET, PLANCHET, COIN }

const WORK_FOR_NEXT_STATE := 1.0

var state: int = State.RAW_METAL

# How much this must be worked to get to the next state
var workForNextState: float = WORK_FOR_NEXT_STATE

# Do a given amount of work on this "coinage thing" so that it eventually gets
# to its next state.
func work(amount: float) -> void:
	# Alrady a coin, there is no next state
	if state == State.COIN:
		return

	workForNextState -= amount
	if workForNextState >= 0:
		match state:
			State.RAW_METAL:
				turnIntoMoltenMetal()
			State.MOLTEN_METAL:
				turnIntoWetPlanchet()
			State.WET_PLANCHET:
				turnIntoPlanchet()
			State.PLANCHET:
				turnIntoCoin()


func turnIntoMoltenMetal() -> void:
	workForNextState = WORK_FOR_NEXT_STATE
	$Sprite.texture = "res://gfx/molten-metal.png"
	
func turnIntoWetPlanchet() -> void:
	workForNextState = WORK_FOR_NEXT_STATE
	$Sprite.texture = "res://gfx/wet-planchet.png"

func turnIntoPlanchet() -> void:
	workForNextState = WORK_FOR_NEXT_STATE
	$Sprite.texture = "res://gfx/planchet.png"

func turnIntoCoin() -> void:
	workForNextState = WORK_FOR_NEXT_STATE
	$Sprite.texture = "res://gfx/coin.png"
