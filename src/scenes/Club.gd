extends Tool

var attackPower := 0.25


func _init():
	coolDownInSecs = 1.0
	chanceToBreak = 0.05
	costAmount = 10
	costTime = 15.0
	toolName = "Club"
	descr = "Not a bad weapon, but has a smallish chance to break."


func useImplementation() -> void:
	useToolToAttack(attackPower)


func showTarget():
	showTargetForWeapon()
