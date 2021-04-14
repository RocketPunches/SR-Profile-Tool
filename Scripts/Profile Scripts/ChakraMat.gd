extends HBoxContainer

var chakra_mat_string

func _on_LineEdit_text_changed(new_text):
	chakra_mat_string = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Chakra Materialization"] = chakra_mat_string
