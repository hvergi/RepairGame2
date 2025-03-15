class_name MainMenu extends Node2D

@export var new_game_window:PackedScene
@export var load_game_window:PackedScene
@export var credits_window:PackedScene
@export var settings_window:PackedScene

@export var main_save_file:SaveFile


const PATH_LAST_PLAYED:String = "user://lastsave.dat"
var path_last_save_file:String


func _ready() -> void:
	%BtnContinue.disabled = !has_last_save()


func has_last_save() -> bool:
	if(FileAccess.file_exists(PATH_LAST_PLAYED)):
		var reader = FileAccess.open(PATH_LAST_PLAYED, FileAccess.READ)
		var save_path = reader.get_as_text()
		reader.close()
		if(FileAccess.file_exists(main_save_file.get_save_path(save_path))):
			path_last_save_file = save_path
			return true
	return false


func _on_btn_new_game_pressed() -> void:
	var window = new_game_window.instantiate()
	%CanvasLayer.add_child(window)


func _on_btn_load_game_pressed() -> void:
	var window = load_game_window.instantiate()
	%CanvasLayer.add_child(window)


func _on_btn_settings_pressed() -> void:
	var window = settings_window.instantiate()
	%CanvasLayer.add_child(window)


func _on_btn_credits_pressed() -> void:
	var window = credits_window.instantiate()
	%CanvasLayer.add_child(window)


func _on_btn_continue_pressed() -> void:
	main_save_file.load_game_path(path_last_save_file)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
