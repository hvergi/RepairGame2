extends WindowTemplate

@export var main_save_file:SaveFile

func _on_button_start_new_game_pressed() -> void:
	var save_name = %LineEditSaveName.text
	var player_name = %LineEditCharacterName.text
	if(save_name == ""):
		%LabelSaveNameError.text = "Save Name Can't be empty."
		return
	if(FileAccess.file_exists("user://" + save_name + SaveFile.SAVE_EXTENSION)):
		%LabelSaveNameError.text = "A save file with that name already exist."
		return
	if(player_name == ""):
		player_name="Insubordinate"
	main_save_file.new_game(save_name,player_name)
	var last_save = FileAccess.open(MainMenu.PATH_LAST_PLAYED,FileAccess.WRITE)
	last_save.store_string(main_save_file.save_name)
	last_save.close()
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
	
