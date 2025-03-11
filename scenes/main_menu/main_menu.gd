extends Node2D


var filepath:String = ""
var file_load_callback = JavaScriptBridge.create_callback(on_file_dialog_confirmed)
var exporthold

func _ready() -> void:
	update_save_list()
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.getFile(file_load_callback)

func update_save_list() -> void:
	%ItemListSaves.clear()
	var files = DirAccess.get_files_at("user://")
	for file:String in files:
		%ItemListSaves.add_item(file.replace(".sav",""))
	update_save_actions(-1)
	
	
func update_save_actions(index: int) -> void:
	if(index == -1):
		%LabelSaveName.text = "Select a save."
		%ButtonLoadGame.visible = false
		%ButtonDeleteSave.visible = false
		%ButtonExportSave.visible = false
		%LabelPlayerName.visible = false
		return
	if(FileAccess.file_exists(filepath)):
		var json_file = FileAccess.open(filepath, FileAccess.READ)
		%LabelSaveName.text = "Save File: " + %ItemListSaves.get_item_text(index)
		%LabelPlayerName.text = json_file.get_as_text()
		%LabelPlayerName.visible = true
		json_file.close()
		%ButtonLoadGame.visible = true
		%ButtonDeleteSave.visible = true
		%ButtonExportSave.visible = true
	else:
		%LabelSaveName.text = "Save File not Found"
		%ButtonLoadGame.visible = false
		%ButtonDeleteSave.visible = false
		%ButtonExportSave.visible = false
		%LabelPlayerName.visible = false


func _on_item_list_saves_item_selected(index: int) -> void:
	filepath = "user://" + %ItemListSaves.get_item_text(index) + ".sav"
	update_save_actions(index)


func _on_button_create_save_pressed() -> void:
	if(%LineEditSaveName.text == ""):
		%LabelSaveNameError.text = "Save File Name cannot be empty"
		return
	if(FileAccess.file_exists("user://" + %LineEditSaveName.text + ".sav")):
		%LabelSaveNameError.text = "Save File With Name Already Exists"
		return
	if(%LineEditPlayerName.text == ""):
		%LineEditPlayerName.text = "Insubordinate"
	var json_file = FileAccess.open("user://" + %LineEditSaveName.text + ".sav", FileAccess.WRITE_READ)
	json_file.store_line(%LineEditPlayerName.text)
	json_file.close()
	update_save_list()
	%CharacterCreation.visible = false
	%LineEditPlayerName.text = ""
	%LineEditSaveName.text = ""
	


func _on_button_new_game_pressed() -> void:
	%CharacterCreation.visible = true


func _on_button_delete_save_pressed() -> void:
	var dialog = ConfirmationDialog.new()
	dialog.title = "Delete Save File"
	dialog.dialog_text = "This action cannot be undone, are you sure you wish to delete this save?"
	dialog.cancel_button_text = "No"
	dialog.ok_button_text = "Yes"
	dialog.confirmed.connect(dialog_confirmed)
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()
	
func dialog_confirmed() -> void:
	if(FileAccess.file_exists(filepath)):
		DirAccess.remove_absolute(filepath)
	update_save_list()
	
func import_dialog_confirmed() -> void:
	var importpath = "user://" + JSON.parse_string(exporthold[0])
	var json_file = FileAccess.open(importpath, FileAccess.WRITE_READ)
	json_file.store_string(JavaScriptBridge.js_buffer_to_packed_byte_array(exporthold[1]).get_string_from_utf8())
	json_file.close()
	update_save_list()


func _on_button_export_save_pressed() -> void:
	if(OS.get_name() == "Web"):
		var save_buffer = FileAccess.get_file_as_bytes(filepath)
		JavaScriptBridge.download_buffer(save_buffer,filepath.replace("user://",""))


func _on_button_import_save_pressed() -> void:
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.input.click()
	
func on_file_dialog_confirmed(args) -> void:
	var importpath = "user://" + JSON.parse_string(args[0])
	if(FileAccess.file_exists(importpath)):
		var dialog = ConfirmationDialog.new()
		dialog.title = "Overwrite Save File"
		dialog.dialog_text = "This action cannot be undone, are you sure you wish to overwrite this save?"
		dialog.cancel_button_text = "No"
		dialog.ok_button_text = "Yes"
		dialog.confirmed.connect(import_dialog_confirmed)
		add_child(dialog)
		dialog.popup_centered()
		dialog.show()
		exporthold = args
		return
	var json_file = FileAccess.open(importpath, FileAccess.WRITE_READ)
	print(JavaScriptBridge.js_buffer_to_packed_byte_array(args[1]))
	json_file.store_string(JavaScriptBridge.js_buffer_to_packed_byte_array(args[1]).get_string_from_utf8())
	json_file.close()
	update_save_list()
