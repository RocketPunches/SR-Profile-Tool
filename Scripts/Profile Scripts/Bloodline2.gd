extends OptionButton

export(NodePath) var bl_1_path
var bloodline_1 = bl_1_path

onready var menu_data = ImportData.menu_data


func populate_dropdown(type_id):
	
	self.clear()
	var index = 0
	
	match type_id:
		"Dojutsu":
			var base_clans = ["Uchiha Clan", "Hyūga Clan", "Kurama Clan"]
			var advanced_clans = ["Mangekyo Sharingan", "Tenseigan", "Ketsuryūgan"]
			
			var first_bloodline = bloodline_1.get_item_text(bloodline_1.get_selected())
			
			for list_item in menu_data["dojutsu_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
				
				if self.get_item_text(index) == first_bloodline:
					self.set_item_disabled(index, true)
				
				if base_clans.has(first_bloodline):
					if base_clans.has(self.get_item_text(index)):
						self.set_item_disabled(index, true)
				elif advanced_clans.has(first_bloodline):
					if advanced_clans.has(self.get_item_text(index)):
						self.set_item_disabled(index, true)
				
				index += 1
			
			while self.is_item_disabled(self.get_selected()):
				self.select(self.get_selected() + 1)
			
		"Chakra Manipulation":
			for list_item in menu_data["chakra_manip_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
				index += 1
		"Elemental":
			for list_item in menu_data["elemental_bloodlines"]["elements"]:
				self.add_item(list_item["element"])
				index += 1


func _on_BloodlineDrop2_item_selected(index):
	OutputData.character_info["Bloodline 2"] = self.get_item_text(index)
