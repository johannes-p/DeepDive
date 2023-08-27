extends Node2D

@onready var game_scene = preload("res://scenes/world.tscn")

func load_game(gamemode : String):
	get_node("/root/Options").mode = gamemode
	var game_scene_instance = game_scene
	get_tree().change_scene_to_packed(game_scene_instance)

func _on_play_button_pressed():
	load_game("normal")


func _on_oxygen_included_play_button_pressed():
	load_game("oxygen_included")
