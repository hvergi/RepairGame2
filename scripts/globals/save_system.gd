extends Node

const SAVE_PREFIX:String = "MRG"
const SAVE_SLOTS:int = 3

var test:String = "NoSave"
var file_load_callback = JavaScriptBridge.create_callback(on_file_dialog_confirmed)

func _ready() -> void:
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.getFile(file_load_callback)

func get_save_at_slot(slot:int) -> void:
	if(FileAccess.file_exists("user://" + SAVE_PREFIX + str(slot) + ".sav")):
		var json_file = FileAccess.open("user://" + SAVE_PREFIX + str(slot) + ".sav", FileAccess.READ)
		test = json_file.get_line()
		json_file.close()

func set_save_at_slot(slot:int) -> void:
	var json_file = FileAccess.open("user://" + SAVE_PREFIX + str(slot) + ".sav", FileAccess.WRITE_READ)
	json_file.store_line("Test")
	json_file.close()

func is_save_in_slot(slot:int) -> bool:
	return FileAccess.file_exists("user://" + SAVE_PREFIX + str(slot) + ".sav")

func delete_save_in_slot(slot:int)-> void:
	if(FileAccess.file_exists("user://" + SAVE_PREFIX + str(slot) + ".sav")):
		DirAccess.remove_absolute("user://" + SAVE_PREFIX + str(slot) + ".sav")
		
func expot_save_in_slot(slot:int) -> void:
	if(OS.get_name() == "Web"):
		var save_buffer = FileAccess.get_file_as_bytes("user://" + SAVE_PREFIX + str(slot) + ".sav")
		JavaScriptBridge.download_buffer(save_buffer,SAVE_PREFIX + str(slot) + ".sav")
		
func import_save_in_slot(slot:int) -> void:
	if(OS.get_name() == "Web"):
		var window = JavaScriptBridge.get_interface("window")
		window.input.click()
	
func on_file_dialog_confirmed(args) -> void:
	var json_file = FileAccess.open("user://" + SAVE_PREFIX + str(1) + ".sav", FileAccess.WRITE_READ)
	json_file.store_buffer(args)
	json_file.close()
	
