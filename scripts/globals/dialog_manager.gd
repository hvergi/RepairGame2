extends Node

func open_yes_no(title:String, question:String, callback:Callable) -> void:
	var dialog = ConfirmationDialog.new()
	dialog.title = title
	dialog.dialog_text = question
	dialog.cancel_button_text = "No"
	dialog.ok_button_text = "Yes"
	dialog.confirmed.connect(callback)
	add_child(dialog)
	dialog.popup_centered()
	dialog.show()
