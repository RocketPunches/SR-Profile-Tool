extends Tabs

var strength_1
var strength_2

# Strength 1
func _on_LineEdit_text_changed(new_text):
	strength_1 = new_text

func _on_LineEdit_focus_exited():
	OutputData.character_info["Strength 1"] = strength_1
	
# Strength 2
func _on_LineEdit2_text_changed(new_text):
	strength_2 = new_text

func _on_LineEdit2_focus_exited():
	OutputData.character_info["Strength 2"] = strength_2
