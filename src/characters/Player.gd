extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 300

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _process(delta):
	# Walk
	var velocity = Vector2()

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	if velocity.length_squared() > 0:
		rotation = velocity.angle() + PI/2

	move_and_slide(velocity)
