extends Node2D

@export var oxygen_scene : PackedScene = null
@export var terrain_tiles : Array[CompressedTexture2D] = []
@export var terrain_scene : PackedScene = null
@export var terrain_depth : int = 10

@onready var left_starting_position = $terrain_start_l.position
@onready var right_starting_position = $terrain_start_r.position

var terrain_offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for index in range(terrain_depth):
		place_terrain(index)

func place_terrain(index):
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
	
	terrain_offset+=1

func _process(delta):
	if $player.position.y > (terrain_offset - 3) * 540:
		for i in range(terrain_depth):
			place_terrain(terrain_offset)

func _on_oxygen_timer_timeout():
	var oxygen_spawn_location = Vector2()
	oxygen_spawn_location.y = $player.position.y + 600
	oxygen_spawn_location.x = randi_range(192, 1728)
	
	var oxygen = oxygen_scene.instantiate()	
	$oxygen_root.add_child(oxygen)
	oxygen.position = oxygen_spawn_location
	
	
