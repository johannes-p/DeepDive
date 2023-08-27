extends Area2D

@onready var hud_node = get_node("../../hud")
@onready var pop_sound = get_node("../../PopSound")
	
func _process(delta):
	position.y-= 250 * delta
	
	if position.y < 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		pop_sound.play()
		hud_node.collected_oxygen()
		queue_free()


func _on_screen_exited():
	queue_free()
