extends Area2D

# 1 right | -1 left
var direction = 1
@export var speed = 150
@export var spawn_probability = 50

@onready var hud = get_node("../../hud")

func _process(delta):
	position.x += speed * delta * direction

func flip():
	$Sprite2D.flip_h = false
	direction = -1
	
func _on_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		hud.remove_heart()
		pass

func get_spawn_probability():
	return spawn_probability
