extends HBoxContainer

var age_string

func _on_LineEdit_text_changed(new_text):
	age_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Age"] = age_string
	#print(OutputData.character_info)
