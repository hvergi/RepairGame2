extends WindowTemplate

@export var save_row_scene:PackedScene

var file_load_callback = JavaScriptBridge.create_callback(on_file_dialog_confirmed)
var importhold

func _ready() -> void:
	update_save_rows()
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.getFile(file_load_callback)
	
	
func update_save_rows() -> void:
	for n:Node in %SaveRowHolder.get_children():
		%SaveRowHolder.remove_child(n)
		n.queue_free()
	var list = DirAccess.get_files_at("user://")
	for file:String in list:
		if(file.ends_with(SaveFile.SAVE_EXTENSION)):
			var save_row:SaveRow = save_row_scene.instantiate() as SaveRow
			save_row.setup_save_row(file)
			%SaveRowHolder.add_child(save_row)


func _on_button_import_save_pressed() -> void:
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.input.click()
	else:
		var fd = FileDialog.new()
		fd.access = FileDialog.ACCESS_FILESYSTEM
		fd.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		fd.add_filter("*.mrg", "Repair Game Save")
		fd.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
		fd.file_selected.connect(on_file_selected)
		add_child(fd)
		fd.popup_centered()

func on_file_selected(args) -> void:
	var save_file = FileAccess.open(args, FileAccess.READ)
	var save_string = save_file.get_as_text()
	save_file.close()
	var save_data:SaveFile = SaveFile.new()
	save_data.set_from_dictionary(JSON.parse_string(save_string))
	if(FileAccess.file_exists(save_data.save_file_path)):
		DialogManager.open_yes_no("Save Overwrite","A save file with this name already exists.\nDo you wish to overwrite it?",save_file_win)
		importhold = save_data
		return
	save_data.save_game()
	update_save_rows()
	

func on_file_dialog_confirmed(args) -> void:
	var importpath = "user://" + JSON.parse_string(args[0])
	importhold = args
	if(FileAccess.file_exists(importpath)):
		DialogManager.open_yes_no("Save Overwrite","A save file with this name already exists.\nDo you wish to overwrite it?",save_file)
		return
	save_file()
	

func save_file() -> void:
	var importpath = "user://" + JSON.parse_string(importhold[0])
	var json_file = FileAccess.open(importpath, FileAccess.WRITE_READ)
	json_file.store_string(JavaScriptBridge.js_buffer_to_packed_byte_array(importhold[1]).get_string_from_utf8())
	json_file.close()
	update_save_rows()
	
func save_file_win() -> void:
	importhold.save_game()
	update_save_rows()
