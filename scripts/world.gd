extends Node2D

@export var oxygen_scene : PackedScene = null
@export var terrain_tiles : Array[CompressedTexture2D] = []
@export var terrain_scene : PackedScene = null
@export var terrain_depth : int = 10
@export var trash_scene : PackedScene = null

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
	
	
	$terrain_root.add_child(left_instance)
	$terrain_root.add_child(right_instance)
	
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
	
func _on_trash_timer_timeout():
	var trash_spawn_location = Vector2()
	trash_spawn_location.y = $player.position.y + 600
	trash_spawn_location.x = randi_range(192, 1728)
	
	var trash = trash_scene.instantiate()	
	$trash_root.add_child(trash)
	trash.position = trash_spawn_location
	
func gameover(reason, depth, collected_trash):
	$player.set_process(false)
	$player.set_velocity(Vector2.ZERO)
	$terrain_root.set_process(false)
	
	$trashTimer.stop()
	$oxygenTimer.stop()
	
	delete_children($fish_root)
	delete_children($oxygen_root)
	delete_children($trash_root)
	
	# prevent gameover screen from being overwritten while visible
	if $gameover_screen.visible:
		return
	
	var reason_text : String
	
	match reason:
		'oxygen':
			reason_text = "ran out of oxygen"
		'health':
			reason_text = "were mortally wounded"
		_:
			reason_text = "did something"
			
	$gameover_screen/RichTextLabel.text = "[center]You [color=teal]" + reason_text + "\n" + str(depth) + "m[/color] below sea level[/center]" 
	$gameover_screen/TrashLabel.text = str(collected_trash)
	
	$gameover_screen.show()

func reset():
	$hud.reset()
	
	$player.position = $starting_position.position
	$player.rotation = 0
	$Camera2D.position.y = $player.position.y
	
	$gameover_screen.hide()
	$player.set_process(true)
	$terrain_root.set_process(true)
	
	$oxygenTimer.start()
	$trashTimer.start()
	
func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
