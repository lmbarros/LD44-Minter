extends Node2D

export(PackedScene) var toolScene: PackedScene = null

var _tool: Node = null # the one the player can equip and use
var _fakeTool: Node = null # hack; always present, just to read info for buying
var _isPlayerHere := false


func _ready() -> void:
	_fakeTool = toolScene.instance()


func _process(delta):
	if _isPlayerHere and Input.is_action_just_pressed("action"):
		if _tool:
			# Equip tool
			_tool.isTaking = true
			Globals.player.setTool(_tool)
		else:
			# Buy (and equip) tool
			_tool = toolScene.instance()
			Globals.addCoinRateModifier("Bought %s" % _tool.toolName, _tool.costTime, -_tool.costAmount)
			_tool.isTaking = true
			Globals.player.setTool(_tool)
			self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_Area2D_body_entered(body):
	if body is Player:
		_isPlayerHere = true
		
	if _tool:
		Globals.helpText = "%s: %s\n\nPress button to equip this!" % [_tool.toolName, _tool.descr]
	else:
		Globals.helpText = "%s: %s\n\nPress button to buy this!\n\n" % [_fakeTool.toolName, _fakeTool.descr]
		Globals.helpText += "Make sure you can afford it: -%s coin rate for %.0fs!\n" % [_fakeTool.costAmount, _fakeTool.costTime]


func _on_Area2D_body_exited(body):
	if body is Player:
		_isPlayerHere = false
		print("Player exited!", body)
	Globals.helpText = ""


func createTool() -> void:
	_tool = toolScene.instance()
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func destroyTool() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 0.25)
