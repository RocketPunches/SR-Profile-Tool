extends HBoxContainer

export(NodePath) var br_value_path
export(NodePath) var chakra_value_path
export(NodePath) var stamina_value_path

onready var br_value = get_node(br_value_path)
onready var chakra_value = get_node(chakra_value_path)
onready var stamina_value = get_node(stamina_value_path)

func update_stats():
	
	OutputData.stat_calc()
	
	br_value.set_text(OutputData.body_rank)
	chakra_value.set_text(str(OutputData.chakra))
	stamina_value.set_text(str(OutputData.stamina))

func reset_stats():
	br_value.set_text("")
	chakra_value.set_text("")
	stamina_value.set_text("")
