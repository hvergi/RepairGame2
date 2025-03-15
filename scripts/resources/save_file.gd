class_name SaveFile extends Resource

const SAVE_EXTENSION:String = ".mrg"
const CURRENT_SAVE_VERSION:int = 1

@export_category("Save Settings")
@export var save_name:String
@export var save_version:int
@export var save_timestamp:String

@export_category("Save Data")
@export var player_data:PlayerData

var save_file_path:String

func get_save_path(file_name:String) -> String:
	if(!file_name.begins_with("user://")):
		file_name = "user://" + file_name
	if(!file_name.ends_with(SAVE_EXTENSION)):
		file_name = file_name+SAVE_EXTENSION
	return file_name

func new_game(save:String, name:String) -> void:
	player_data.new_game(name)
	save_name = save
	save_file_path = "user://" + save_name + SAVE_EXTENSION
	save_game()

func save_game() -> void:
	var save_string:String = JSON.stringify(get_save_dictionary())
	var save = FileAccess.open(save_file_path,FileAccess.WRITE)
	if(save!=null):
		save.store_string(save_string)
		save.close()
	
func load_game() -> void:
	if(FileAccess.file_exists(save_file_path)):
		var save = FileAccess.open(save_file_path,FileAccess.READ)
		var save_string:String = save.get_as_text()
		save.close()
		set_from_dictionary(JSON.parse_string(save_string))
		
	
func load_game_path(path:String) -> void:
	save_name = path
	save_file_path = get_save_path(path)
	load_game()
	
func get_save_dictionary() -> Dictionary:
	var save_dict:Dictionary = {}
	save_dict["save_name"] = save_name
	save_dict["save_version"] = CURRENT_SAVE_VERSION
	save_dict["save_timestamp"] = Time.get_datetime_string_from_system(true,true)
	save_dict["player_data"] = player_data.get_player_dictionary()
	return save_dict
	
func set_from_dictionary(save_dict:Dictionary) -> void:
	upgrade_save(save_dict)
	save_name = save_dict["save_name"]
	save_file_path = get_save_path(save_dict["save_name"])
	save_version = save_dict["save_version"]
	save_timestamp = save_dict["save_timestamp"]
	if(player_data==null):
		player_data = PlayerData.new()
	player_data.set_player_from_dictionary(save_dict["player_data"])
	
func upgrade_save(save_dict:Dictionary) -> Dictionary:
	return save_dict
