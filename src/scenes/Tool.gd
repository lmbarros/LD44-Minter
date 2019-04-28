extends Node2D
class_name Tool

# Override those in subclasses!
var coolDownInSecs := 0.0
var chanceToBreak := 0.0

var _coolDownTimer := 0.0


func _process(delta: float) -> void:
	_coolDownTimer -= delta


func use() -> void:
	_coolDownTimer = coolDownInSecs
	$AnimationPlayer.play("use")
	useImplementation()


func canUse() -> bool:
	return _coolDownTimer <= 0.0


# To be overriden in subclasses
func useImplementation() -> void:
	assert(false)
