extends HBoxContainer

var weight_string

func _on_LineEdit_text_changed(new_text):
	weight_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Weight"] = weight_string
