extends Node2D

func _init() -> void:
	Globals.initGameState()


func _ready() -> void:
	Globals.gameScene = self
	SoundManager.startMusic()


func _exit_tree():
	SoundManager.stopMusic()
