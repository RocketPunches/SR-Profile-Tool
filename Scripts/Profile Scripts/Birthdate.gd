extends HBoxContainer

var birthdate_string

func _on_LineEdit_text_changed(new_text):
	birthdate_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Birthdate"] = birthdate_string
	#print(OutputData.character_info)
