extends HBoxContainer

var height_string

func _on_LineEdit_text_changed(new_text):
	height_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Height"] = height_string
