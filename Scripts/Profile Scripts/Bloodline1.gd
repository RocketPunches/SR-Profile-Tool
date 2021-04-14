extends OptionButton

export(NodePath) var bloodline_type_path

onready var bloodline_type = get_node(bloodline_type_path)
onready var menu_data = ImportData.menu_data

func populate_dropdown(type_id):
	
	self.clear()
	
	match type_id:
		"Dojutsu":
			for list_item in menu_data["dojutsu_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
		"Chakra Manipulation":
			for list_item in menu_data["chakra_manip_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
		"Elemental":
			for list_item in menu_data["elemental_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
