extends CharacterBody2D


const SPEED : float = 300.0
const ROTATION_AMOUNT : int = 2
const FRICTION : float = 0.025


func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		rotation += ROTATION_AMOUNT * delta
	elif Input.is_action_pressed("move_left"):
		rotation -= ROTATION_AMOUNT * delta
		
	if Input.is_action_pressed("move_forward"):
		velocity = Vector2(1,0).rotated(rotation) * SPEED
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)

	move_and_slide()
