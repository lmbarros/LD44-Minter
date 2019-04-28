extends "res://scenes/Tool.gd"

var fixPower := 0.0

func _ready():
	coolDownInSecs = 5.0
	chanceToBreak = 0.0
	fixPower = Globals.MACHINE_DECAY_RATE * coolDownInSecs * 1.5

func useImplementation() -> void:
	useToolToFix(fixPower)
