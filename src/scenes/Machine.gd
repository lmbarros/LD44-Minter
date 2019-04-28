extends Node2D
class_name Machine

var condition: float = 1.0

# Machine condition will decay this amount per second
const DECAY_RATE := 1.0 / 100

onready var conditionGrad = preload("res://gfx/machine-condition.tres") as Gradient


func _process(delta: float) -> void:
	condition -= delta * DECAY_RATE
	condition = max(0.0, condition)
	$ConditionLabel.text = str(int(condition * 100)) + "%"
	$ConditionLabel.add_color_override(
		"font_color", conditionGrad.interpolate(condition))


func fix(amount: float) -> void:
	condition += amount
	condition = min(condition, 1.0)
