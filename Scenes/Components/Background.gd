extends VBoxContainer

onready var node_ref = get_node("TextEdit")


func _on_TextEdit_focus_exited():
	OutputData.character_info["Background"] = node_ref.get_text()
