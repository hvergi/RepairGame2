class_name SaveRow extends HBoxContainer

@export var main_save_file:SaveFile

var this_save:SaveFile = SaveFile.new()

func setup_save_row(save_file_path:String) -> void:
	this_save.load_game_path(save_file_path)
	%LabelSaveName.text = "Save Name: " + this_save.save_name
	%LabelPlayerName.text = "Player Name: " + this_save.player_data.player_name
	%LabelTimeStamp.text = "Last Played: " + this_save.save_timestamp


func _on_button_load_game_pressed() -> void:
	main_save_file.load_game_path(this_save.save_name)
	var last_save = FileAccess.open(MainMenu.PATH_LAST_PLAYED,FileAccess.WRITE)
	last_save.store_string(main_save_file.save_name)
	last_save.close()
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")


func _on_button_export_save_pressed() -> void:
	if(OS.get_name() == "Web"):
		var save_buffer = FileAccess.get_file_as_bytes(this_save.save_file_path)
		JavaScriptBridge.download_buffer(save_buffer,this_save.save_file_path.replace("user://",""))
	else:
		var fd = FileDialog.new()
		fd.access = FileDialog.ACCESS_FILESYSTEM
		fd.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		fd.add_filter("*.mrg", "Repair Game Save")
		fd.current_file = this_save.save_name
		fd.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
		fd.file_selected.connect(on_file_dialog_confirmed)
		add_child(fd)
		fd.popup_centered()

func on_file_dialog_confirmed(args) -> void:
	var temp:String = this_save.save_file_path
	this_save.save_file_path = args
	this_save.save_game()
	this_save.save_file_path = temp
	



func _on_button_delete_save_pressed() -> void:
	DialogManager.open_yes_no("Delete Save", "Warning: This action can NOT be undone.\n Do you wish to delete this save?",on_dialog_confirm)
	
func on_dialog_confirm() -> void:
	DirAccess.remove_absolute(this_save.save_file_path)
	queue_free()
