extends Node2D
@export var save_file:SaveFile

var cd = 0

func _ready() -> void:
	print("Name: " + save_file.player_data.player_name)
	
func _process(delta: float) -> void:
	cd+=delta
	if(cd > 3):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
