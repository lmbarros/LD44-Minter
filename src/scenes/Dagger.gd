extends Tool

var attackPower := 0.1


func _init():
	coolDownInSecs = 1.0
	chanceToBreak = 0.0
	costAmount = 0
	costTime = 0.0
	toolName = "Dagger"
	descr = "Weak and faithful. Never breaks, but is a weak weapon"


func useImplementation() -> void:
	useToolToAttack(attackPower)


func showTarget():
	showTargetForWeapon()
