extends "res://scenes/Tool.gd"

const FIX_POWER := 0.1


func _ready():
	coolDownInSecs = 4.0
	chanceToBreak = 0.01


func useImplementation() -> void:
	useToolToFix(FIX_POWER)
