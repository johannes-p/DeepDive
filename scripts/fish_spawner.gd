extends Sprite2D

var spawn_probability = 50
var timeout_duration = 5

@export var fish_scenes : Array[PackedScene]
@export var spawn_probabilities : Array[int]

var in_timeout = false
@onready var fish_root = get_node('../fish_root')

#TODO: check if visible on screen before spawning

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not in_timeout:
		in_timeout = true
		var chance = randi_range(0, 100)
		for spawn_index in len(spawn_probabilities):
			if chance < spawn_probabilities[spawn_index]:
				# spawn fish
				var fish = fish_scenes[spawn_index].instantiate()
				var spawn_position = Vector2(position.x, position.y + + randi_range(-100,100))
				
				if self.flip_h == true:
					fish.flip()
				
				fish.position = spawn_position
				fish_root.add_child(fish)
				break
				
		await get_tree().create_timer(timeout_duration).timeout
		in_timeout = false
