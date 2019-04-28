extends "res://scenes/Tool.gd"

var fixPower := 0.0


func _init():
	coolDownInSecs = 5.0
	chanceToBreak = 0.0
	costAmount = 0
	costTime = 0.0
	toolName = "Wrench"
	descr = "The standard maintenance tool. Not very good, but it is unbreakable."
	fixPower = Globals.MACHINE_DECAY_RATE * coolDownInSecs * 1.5


func useImplementation() -> void:
	useToolToFix(fixPower)


func showTarget():
	showTargetForTool()
