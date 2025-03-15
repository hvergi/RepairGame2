class_name SaveData
extends Resource

@export var PlayerName:String
@export var RepairLevel:float = 1.0
@export var Coins:int = 0
@export var SaveDate:String = ""
@export var SaveVersion:int = 1
@export var SaveFileName:String = "blank.sav"

func set_from_save_dict(dict:Dictionary) -> void:
	PlayerName = dict["PlayerName"]
	RepairLevel = dict["RepairLevel"]
	Coins = dict["Coins"]
	SaveDate = dict["SaveDate"]
	SaveVersion = dict["SaveVersion"]
	SaveFileName = dict["SaveFileName"]
	
func get_dict_from_save() -> Dictionary:
	var dict:Dictionary = {}
	dict["PlayerName"] = PlayerName
	dict["RepairLevel"] = RepairLevel
	dict["Coins"] = Coins
	dict["SaveDate"] = SaveDate
	dict["SaveVersion"] = SaveVersion
	dict["SaveFileName"] = SaveFileName
	return dict
	
func save_to_file() -> void:
	SaveDate = Time.get_datetime_string_from_system()
	#add global data for save versioning
	var json_file = FileAccess.open(SaveFileName, FileAccess.WRITE)
	json_file.store_string(JSON.stringify(get_dict_from_save()))
	
func setup_save_data(player_name:String, save_file:String) -> void:
	PlayerName = player_name
	SaveFileName = save_file
	
