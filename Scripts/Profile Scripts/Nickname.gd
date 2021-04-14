extends HBoxContainer

var nickname_string

func _on_LineEdit_text_changed(new_text):
	nickname_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Nickname"] = nickname_string
	#print(OutputData.character_info)
