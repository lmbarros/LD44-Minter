extends Node2D

export(PackedScene) var toolScene: PackedScene = null

var _tool: Node = null
var _isPlayerHere := false


func _process(delta):
	if _isPlayerHere and Input.is_action_just_pressed("action"):
		if _tool:
			Globals.player.setTool(_tool)


func _on_Area2D_body_entered(body):
	if body is Player:
		_isPlayerHere = true
		print("Player entered!", body)


func _on_Area2D_body_exited(body):
	if body is Player:
		_isPlayerHere = false
		print("Player exited!", body)


func createTool() -> void:
	_tool = toolScene.instance()
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func destroyTool() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 0.25)
