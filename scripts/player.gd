extends CharacterBody2D

signal update_depth()

@export var camera_node : Camera2D = null

@onready var screensize : Vector2 = DisplayServer.window_get_size()

const SPEED : float = 300.0
const ROTATION_AMOUNT : int = 2
const FRICTION : float = 0.015


var recently_got_oxygen = false


func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		rotation += ROTATION_AMOUNT * delta
	elif Input.is_action_pressed("move_left"):
		rotation -= ROTATION_AMOUNT * delta
		
	if Input.is_action_pressed("move_forward"):
		velocity = Vector2(1,0).rotated(rotation) * SPEED
		$AnimationPlayer.current_animation = 'swim'
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		$AnimationPlayer.current_animation = 'idle'

	move_and_slide()
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, INF)
	camera_node.position.y = position.y
	
	emit_signal("update_depth", int((position.y / (270.0 / 1.80))))
