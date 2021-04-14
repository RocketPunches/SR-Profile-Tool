extends HBoxContainer

var gender_string

func _on_LineEdit_text_changed(new_text):
	gender_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Gender"] = gender_string
	#print(OutputData.character_info)
