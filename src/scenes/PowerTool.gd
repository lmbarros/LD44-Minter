extends Tool

var fixPower := 0.0


func _init():
	coolDownInSecs = 1.5
	chanceToBreak = 0.15
	costAmount = 22
	costTime = 18.0
	toolName = "Power Tool"
	descr = "Fixes machinery as no other tool, but breaks easily."
	fixPower = Globals.MACHINE_DECAY_RATE * coolDownInSecs * 8.5


func useImplementation() -> void:
	SoundManager.drill()
	useToolToFix(fixPower)


func showTarget():
	showTargetForTool()
