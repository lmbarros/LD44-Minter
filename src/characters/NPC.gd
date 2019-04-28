extends KinematicBody2D
class_name NPC

# Are we doing something?
var _doingSomething := false

var _health := 1.0

# The navigation node
var _nav: Navigation2D

# The function to do when arriving at the destination, and its argument
var _funcToDo := ""
var _funcToDoArg = null

var speed := 200.0

# Will consider arrived if this-squared-close to the target
const ARRIVAL_DELTA = 15*15

# The path being followed by the NPC
var _path: PoolVector2Array


func _ready():
	_nav = get_tree().get_nodes_in_group("Navigation")[0] as Navigation2D


func _process(delta: float) -> void:
	_processAI(delta)

	if _path.size() > 0:
		if position.distance_squared_to(_path[0]) > ARRIVAL_DELTA:
			# Moving
			var velocity = (_path[0] - position).normalized() * speed
			rotation = velocity.angle()
			move_and_slide(velocity)
		else:
			# Arrived at waypoint
			_path.remove(0)

			if _path.size() == 0:
				# Arrived at destination
				if _funcToDo != "":
					self.call(_funcToDo, _funcToDoArg)


	# debugPathLine()


# Goes to target, then calls funcToDo(funcToDoArg).
func moveToThenDo(target: Vector2, funcToDo: String = "", funcToDoArg = null):
	_funcToDo = funcToDo
	_funcToDoArg = funcToDoArg

	_path = _nav.get_simple_path(position, target, true)


func debugPathLine():
	$PathLine.clear_points()
	$PathLine.global_rotation = 0.0
	for p in _path:
		$PathLine.add_point(p - global_position)


func _processAI(_deltaInSecs: float) -> void:
	pass


func doNothing(_arg) -> void:
	_doingSomething = false


func doLeave(_arg) -> void:
	queue_free()


func receiveDamage(damage: float) -> void:
	_health -= damage
	SoundManager.hit()
	if _health <= 0.0:
		SoundManager.die()
		die()


# Override in subclasses!
func die() -> void:
	assert(false)
