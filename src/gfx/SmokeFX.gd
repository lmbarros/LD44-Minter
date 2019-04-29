extends Node2D

func _ready():
	$Particles.emitting = true
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()
