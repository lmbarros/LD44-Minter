extends Node2D
class_name Tool

# Override those in subclasses!
var coolDownInSecs := 0.0
var chanceToBreak := 0.0
var toolName := ""
var descr := ""
var costAmount := 0
var costTime := 0.0

var _coolDownTimer := 0.0

# The tool point of this tool
var toolPoint = null

# True if player is taking it; hack to avoid using it when taking it
var isTaking := false


func _process(delta: float) -> void:
	_coolDownTimer -= delta
	$TargetHighlight/Sprite.rotation += delta * 2 * PI
	showTarget()


func use() -> void:
	if isTaking:
		return

	if get_parent() and canUse():
		_coolDownTimer = coolDownInSecs
		$AnimationPlayer.play("use")
		useImplementation()

	# Did it break?
	if randf() < chanceToBreak:
		Globals.player.removeTool()
		toolPoint.destroyTool()


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
		if machine.position.distance_to(Globals.player.position) < 55:
			return machine
	return null


# To be overriden by subclassses
func showTarget() -> void:
	assert(false)


func showTargetForTool():
	var machine := getNearbyMachine()
	if machine == null:
		$TargetHighlight.visible = false
	else:
		$TargetHighlight.visible = true
		$TargetHighlight.global_position = machine.global_position
