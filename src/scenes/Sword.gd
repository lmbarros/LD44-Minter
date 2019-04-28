extends Tool

var attackPower := 1.2


func _init():
	coolDownInSecs = 1.0
	chanceToBreak = 0.12
	costAmount = 15
	costTime = 20.0
	toolName = "Sword"
	descr = "Low quality sword. One-hit kills, but breaks easily."


func useImplementation() -> void:
	useToolToAttack(attackPower)


func showTarget():
	showTargetForWeapon()
