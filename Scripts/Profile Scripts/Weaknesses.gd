extends Tabs

var weakness_1
var weakness_2

# weakness_1
func _on_LineEdit_text_changed(new_text):
	weakness_1 = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Weakness1"] = weakness_1

# weakness_2
func _on_LineEdit2_text_changed(new_text):
	weakness_2 = new_text

func _on_LineEdit2_focus_exited():
	OutputData.character_info["Weakness2"] = weakness_2
