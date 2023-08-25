extends Area2D

@onready var hud_node = get_node("../../hud")
	
func _process(delta):
	position.y-= 250 * delta
	
	if position.y < 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		hud_node.collected_oxygen()
		queue_free()


func _on_screen_exited():
	queue_free()
