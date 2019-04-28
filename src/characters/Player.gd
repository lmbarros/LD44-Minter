extends KinematicBody2D
class_name Player

const SPEED = 300


func _ready():
	Globals.player = self


func _process(delta: float) -> void:
	_processWalk(delta)
	_processAction(delta)


func _processAction(_delta: float) -> void:
	if !Input.is_action_just_pressed("action"):
		return

	var currTool := getTool()
	if currTool:
		currTool.use()


func _processWalk(_delta: float) -> void:
	var velocity := Vector2()

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	if velocity.length_squared() > 0:
		rotation = velocity.angle()

	move_and_slide(velocity)


func setTool(newTool: Tool) -> void:
	var currTool := getTool()
	if currTool:
		$ToolSlot.remove_child(currTool)

	$ToolSlot.add_child(newTool)
	call_deferred("noLongerTakingTool")


func noLongerTakingTool() -> void:
	var currTool := getTool()
	if currTool:
		currTool.isTaking = false


func getTool() -> Node:
	return null if $ToolSlot.get_child_count() == 0 else $ToolSlot.get_child(0)


func removeTool() -> void:
	var t := getTool()
	if t:
		$ToolSlot.remove_child(t)
