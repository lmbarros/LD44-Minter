extends Node2D

func _init() -> void:
	Globals.initGameState()


func _ready() -> void:
	Globals.gameScene = self
