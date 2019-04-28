extends Node2D
class_name Tool

# Override those in subclasses!
var coolDownInSecs := 0.0
var chanceToBreak := 0.0

var _coolDownTimer := 0.0


func _process(delta: float) -> void:
	_coolDownTimer -= delta


func use() -> void:
	if get_parent() and canUse():
		_coolDownTimer = coolDownInSecs
		$AnimationPlayer.play("use")
		useImplementation()


func canUse() -> bool:
	return _coolDownTimer <= 0.0


# To be overriden in subclasses
func useImplementation() -> void:
	assert(false)


# Assuming this is a fixing tool
func useToolToFix(amount: float) -> void:
	var machine := getNearbyMachine()
	if machine:
		machine.fix(amount)


func getNearbyMachine() -> Machine:
	var machines := get_tree().get_nodes_in_group("Machines")
	for machine in machines:
		if machine.position.distance_to(Globals.player.position) < 32:
			return machine
	return null