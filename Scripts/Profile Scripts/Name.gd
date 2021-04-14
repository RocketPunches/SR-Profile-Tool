extends HBoxContainer

var name_string
	
func _on_LineEdit_text_changed(new_text):
	name_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Full Name"] = name_string
	#print(OutputData.character_info)
