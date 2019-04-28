extends Tool

var attackPower := 0.1


func _init():
	coolDownInSecs = 1.0
	chanceToBreak = 0.0
	costAmount = 0
	costTime = 0.0
	toolName = "Dagger"
	descr = "An old dagger. Never breaks, but doesn't damage much more than a mosquito bite."


func useImplementation() -> void:
	useToolToAttack(attackPower)


func showTarget():
	showTargetForWeapon()
