extends "res://scenes/Tool.gd"

const FIX_POWER := 0.05


func _ready():
	coolDownInSecs = 10.0
	chanceToBreak = 0.0


func useImplementation() -> void:
	useToolToFix(FIX_POWER)
