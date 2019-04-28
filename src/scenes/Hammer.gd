extends "res://scenes/Tool.gd"

var fixPower := 0.0


func _init():
	coolDownInSecs = 2.0
	chanceToBreak = 0.01
	costAmount = 10
	costTime = 15.0
	toolName = "Hammer"
	descr = "All your problems look like nails anyway. A bit better than a wrench, doesn't break easily."
	fixPower = Globals.MACHINE_DECAY_RATE * coolDownInSecs * 10.0


func useImplementation() -> void:
	SoundManager.hammer()
	useToolToFix(fixPower)


func showTarget():
	showTargetForTool()
