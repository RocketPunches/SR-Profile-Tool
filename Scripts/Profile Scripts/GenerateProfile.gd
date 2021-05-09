extends Button

export(NodePath) var profile_text_path
export(NodePath) var final_pop_path

onready var profile_text = get_node(profile_text_path)
onready var final_pop = get_node(final_pop_path)

func _on_GenerateButton_pressed():
	
	profile_text.set_text(OutputData.format_profile())
	
	final_pop.popup_centered()
