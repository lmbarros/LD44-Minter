extends Node2D
class_name Machine

var condition: float = 1.0

onready var conditionGrad = preload("res://gfx/machine-condition.tres") as Gradient
export(String) var machineName: String = ""


func _process(delta: float) -> void:
	condition -= delta * Globals.MACHINE_DECAY_RATE
	condition = max(0.0, condition)
	$ConditionLabel.text = str(int(condition * 100)) + "%"
	$ConditionLabel.add_color_override(
		"font_color", conditionGrad.interpolate(condition))


func fix(amount: float) -> void:
	SoundManager.fix()
	condition += amount
	condition = min(condition, 1.0)


onready var SmokeFX := preload("res://gfx/SmokeFX.tscn")
func suddenBreak() -> void:
	SoundManager.breaking()
	condition -= rand_range(0.3, 1.0)
	condition = max(condition, 0.0)
	add_child(SmokeFX.instance())
