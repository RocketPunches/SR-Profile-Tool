extends OptionButton

export(NodePath) var bloodline_type_path
export(NodePath) var bloodline_type_2_path

onready var bloodline_type = get_node(bloodline_type_path)
onready var bloodline_type_2 = get_node(bloodline_type_2_path)
onready var menu_data = ImportData.menu_data

func populate_dropdown(type_id):
	
	self.clear()
	
	match type_id:
		"Dojutsu":
			self.add_item("None")
			for list_item in menu_data["dojutsu_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
		"Chakra Manipulation":
			self.add_item("None")
			for list_item in menu_data["chakra_manip_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
		"Elemental":
			self.add_item("None")
			for list_item in menu_data["elemental_bloodlines"]["elements"]:
				self.add_item(list_item["element"])


func _on_BloodlineDrop1_item_selected(index):
	if bloodline_type_2.is_disabled():
		bloodline_type_2.set_disabled(false)
	
	OutputData.character_info["Bloodline 1"] = self.get_item_text(index)
