extends Area2D

@export var trash_textures : Array[CompressedTexture2D] = []
@onready var crunch_sound = get_node("../../CrunchSound")

var hud : Node

func _ready():
	$Sprite2D.texture = trash_textures[randi() % trash_textures.size()]
	rotation = randi() % 360
	hud = get_node("../../hud")

func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		crunch_sound.play()
		hud.pickup_trash()
		queue_free()
