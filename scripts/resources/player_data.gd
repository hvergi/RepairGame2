class_name PlayerData extends Resource

@export var player_name:String
@export var repair_level:float
@export var coins:int




func new_game(name:String) -> void:
	player_name = name
	repair_level = 1.0
	coins = 0

func get_player_dictionary() -> Dictionary:
	var player_dict = {}
	player_dict["player_name"] = player_name
	player_dict["repair_level"] = repair_level
	player_dict["coins"] = coins
	return player_dict
	
func set_player_from_dictionary(player_dict:Dictionary) -> void:
	player_name = player_dict["player_name"]
	repair_level = player_dict["repair_level"]
	coins = player_dict["coins"]
