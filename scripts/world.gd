extends Node2D

@export var terrain_tiles : Array[CompressedTexture2D] = []
@export var terrain_scene : PackedScene = null
@export var terrain_depth : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var left_starting_position = $terrain_start_l.position
	var right_starting_position = $terrain_start_r.position
	
	for index in range(terrain_depth):
		
		# instanciate terrain 'object'
		var left_instance = terrain_scene.instantiate()
		var right_instance = terrain_scene.instantiate()
		
		
		# set random sprite
		var sprite_index = randi() % len(terrain_tiles)
		left_instance.texture = terrain_tiles[sprite_index]
		
		sprite_index = randi() % len(terrain_tiles)
		right_instance.texture = terrain_tiles[sprite_index]
		
		
		# position the terrain - sprite height = 540px
		left_instance.global_position = Vector2(left_starting_position.x, \
		left_starting_position.y + (index * 540))
		
		right_instance.global_position = Vector2(right_starting_position.x, \
		right_starting_position.y + (index * 540))
		
		#flip sprite for right instance
		right_instance.flip_h = true
		
		
		add_child(left_instance)
		add_child(right_instance)


func _on_player_update_depth():
	pass # Replace with function body.
