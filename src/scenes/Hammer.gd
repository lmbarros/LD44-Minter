extends "res://scenes/Tool.gd"

var fixPower := 0.0


func _ready():
	coolDownInSecs = 4.0
	chanceToBreak = 0.01
	fixPower = Globals.MACHINE_DECAY_RATE * coolDownInSecs * 2.5


func useImplementation() -> void:
	useToolToFix(fixPower)


func showTarget():
	showTargetForTool()
