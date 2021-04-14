extends Tabs

var fear_1
var fear_2

# fear_1
func _on_LineEdit_text_changed(new_text):
	fear_1 = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Fear1"] = fear_1

# fear_2
func _on_LineEdit2_text_changed(new_text):
	fear_2 = new_text

func _on_LineEdit2_focus_exited():
	OutputData.character_info["Fear2"] = fear_2
