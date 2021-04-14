extends HBoxContainer

var chakra_color_string

func _on_LineEdit_text_changed(new_text):
	chakra_color_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Chakra Color"] = chakra_color_string
