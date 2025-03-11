extends Control
@export var slot_number:int

func _ready() -> void:
	%LabelTitle.text = "Save Slot: " + str(slot_number)
	updateUI()



func updateUI() -> void:
	if(SaveSystem.is_save_in_slot(slot_number)):
		%LabelUserName.visible = true
		%LabelLevel.visible = true
		%LabelCoins.visible = true
		%LabelTimeStamp.visible = true
		%ButtonLoad.visible = true
		%ButtonExport.visible = true
		%ButtonDelete.visible = true
		%ButtonImport.visible = false
		%ButtonNewGame.visible = false
		%LabelEmpty.visible = false
	else:
		%ButtonImport.visible = true
		%ButtonNewGame.visible = true
		%LabelEmpty.visible = true
		%LabelUserName.visible = false
		%LabelLevel.visible = false
		%LabelCoins.visible = false
		%LabelTimeStamp.visible = false
		%ButtonLoad.visible = false
		%ButtonExport.visible = false
		%ButtonDelete.visible = false


func _on_button_delete_pressed() -> void:
	var dialog = ConfirmationDialog.new()
	dialog.title = "Delete Save File"
	dialog.dialog_text = "This action cannot be undone, are you sure you wish to delete this save?"
	dialog.cancel_button_text = "No"
	dialog.ok_button_text = "Yes"
	dialog.dialog_close_on_escape = false
	dialog.confirmed.connect(dialog_confirmed)
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()
	
func dialog_confirmed() -> void:
	SaveSystem.delete_save_in_slot(slot_number)
	updateUI()


func _on_button_new_game_pressed() -> void:
	SaveSystem.set_save_at_slot(slot_number)
	updateUI()


func _on_button_import_pressed() -> void:
	SaveSystem.import_save_in_slot(slot_number)
	updateUI()


func _on_button_export_pressed() -> void:
	SaveSystem.expot_save_in_slot(slot_number)
	updateUI()
	
