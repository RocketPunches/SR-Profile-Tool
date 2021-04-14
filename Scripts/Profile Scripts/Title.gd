extends HBoxContainer

var title_string

func _on_LineEdit_text_changed(new_text):
	title_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Title"] = title_string
