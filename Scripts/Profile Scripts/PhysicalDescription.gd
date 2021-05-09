extends VBoxContainer

export(NodePath) var text_edit_path
onready var text_edit = get_node(text_edit_path)

func _on_TextEdit_focus_exited():
	OutputData.character_info["Physical Description"] = text_edit.get_text()
