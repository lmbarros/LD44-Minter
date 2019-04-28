extends KinematicBody2D

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
	moveToThenDo(Vector2(480, 400), "nothing")


func nothing(_dummy) -> void:
	Globals.showToast("Arrived!")


func _process(delta: float) -> void:
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
				_funcToDo = ""
				_funcToDoArg = null
				
	debugPathLine()


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
