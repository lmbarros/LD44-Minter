extends Node2D

var _canGo := false

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	_canGo = true

func _input(event) -> void:
	if _canGo && event is InputEventKey or event is InputEventJoypadButton:
    	get_tree().change_scene("res://screens/GameScreen.tscn")
