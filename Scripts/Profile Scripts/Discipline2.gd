extends OptionButton

export(NodePath) var discipline_1_path
export(NodePath) var class_1_path
export(NodePath) var class_2_path

onready var discipline_1 = get_node(discipline_1_path)
onready var class_1 = get_node(class_1_path)
onready var class_2 = get_node(class_2_path)

onready var class_data = ImportData.class_data

func populate_dropdown(class_id):
	
	self.clear()
	
	for discipline in class_data[class_id]["disciplines"]:
		self.add_item(discipline["discipline_name"])
	
	var first_class = class_1.get_selected()
	var second_class = class_2.get_selected()
	var d1_index = discipline_1.get_selected()
	
	if first_class == second_class:
		if d1_index == 0:
			self.select(1)
		self.set_item_disabled(d1_index, true) # this does not work, and I have no idea why
	
	self.check_keystone()
	discipline_1.check_bloodline()
	
	OutputData.character_info["Discipline 2"] = self.selected_text()
	
func _on_DiscDrop2_item_selected(index):
	OutputData.character_info["Discipline 2"] = self.get_item_text(index)
	discipline_1.check_bloodline()

func remote_update_disc():
	OutputData.character_info["Discipline 2"] = self.selected_text()

func selected_text():
	if self.items.size() == 0: # Returns the same thing as empty selection but without yelling at me about a pointless error and pissing me the hell off
		return
	return self.get_item_text(self.get_selected())

func check_keystone():
	
	var keystone_selected = false
	
	var keystones = [
		"Genius Keystone", 
		"Brawler", 
		"Heritage Keystone",
		"Expert",
		"Maladies Physician",
		]
	
	for discipline in keystones:
		if discipline_1.selected_text() == discipline:
			keystone_selected = true
	
	if keystone_selected:
		if self.items.size() == 0:
			return
		for i in range(3):
			for discipline in keystones:
				if self.get_item_text(i) == discipline:
					
					self.set_item_disabled(i, true)
					
					if self.get_selected() == i:
						self.select(1)
	else:
		if self.items.size() == 0:
			return
		for i in range(3):
			if self.is_item_disabled(i):
				self.set_item_disabled(i, false)
