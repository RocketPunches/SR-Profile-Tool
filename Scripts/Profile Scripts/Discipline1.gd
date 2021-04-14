extends OptionButton

export(NodePath) var discipline_2_path
export(NodePath) var class_1_path
export(NodePath) var class_2_path
export(NodePath) var bl_label_path
export(NodePath) var bloodline_1_path
export(NodePath) var bloodline_2_path

onready var discipline_2 = get_node(discipline_2_path)
onready var class_1 = get_node(class_1_path)
onready var class_2 = get_node(class_2_path) 
onready var bl_label = get_node(bl_label_path)
onready var bloodline_1 = get_node(bloodline_1_path)
onready var bloodline_2 = get_node(bloodline_2_path)

onready var class_data = ImportData.class_data

func populate_dropdown(class_id):
	
	self.clear()
	
	for discipline in class_data[class_id]["disciplines"]:
		self.add_item(discipline["discipline_name"])
	
	var first_class = class_1.selected_text()
	var second_class = class_2.selected_text()
	
	if first_class == second_class:
		
		if class_1.get_selected() == class_2.get_selected():
			
			if discipline_2.get_selected() == 0:
				discipline_2.select(1)
		
		discipline_2.set_item_disabled(self.get_selected(), true)
	
	self.check_keystone()
	self.check_bloodline()
	
	OutputData.character_info["Discipline 1"] = self.selected_text()
	
	if class_2.is_disabled():
		class_2.set_disabled(false)

func _on_DiscDrop1_item_selected(index):
	
	if self.get_item_text(index) == discipline_2.selected_text():
		if discipline_2.get_selected() == 0 or discipline_2.get_selected() == 2:
			discipline_2.select(1)
			discipline_2.set_item_disabled(1, false)
		else: 
			discipline_2.select(0)
			discipline_2.set_item_disabled(0, false)
			discipline_2.set_item_disabled(2, false)
		
		discipline_2.set_item_disabled(index, true)
	
	self.check_keystone()
	discipline_2.check_keystone()
	discipline_2.remote_update_disc()
	self.check_bloodline()
	
	OutputData.character_info["Discipline 1"] = self.get_item_text(index)

func check_keystone():
	
	var d1_is_keystone = false
	var d2_is_keystone = false
	
	var disc_1 = self.selected_text()
	var disc_2 = discipline_2.selected_text()
	var disc_2_index = discipline_2.get_selected()
	
	var keystones = [
		"Genius Keystone", 
		"Brawler", 
		"Heritage Keystone",
		"Expert",
		"Maladies Physician",
		]
		
	for discipline in keystones:
		if discipline == disc_1:
			d1_is_keystone = true
		if discipline == disc_2:
			d2_is_keystone = true
	
	if d1_is_keystone and d2_is_keystone:
		if discipline_2.get_selected() == 0 or discipline_2.get_selected() == 2:
			discipline_2.select(1)
			discipline_2.set_item_disabled(1, false)
		else: 
			discipline_2.select(0)
			discipline_2.set_item_disabled(0, false)
			discipline_2.set_item_disabled(2, false)
		
		discipline_2.set_item_disabled(disc_2_index, true)

func check_bloodline():
	
	var first_class = class_1.selected_text()
	var second_class = class_2.selected_text()
	
	if self.selected_text() == "Dual Ancestry" or discipline_2.selected_text() == "Dual Ancestry":
		bl_label.text = "Bloodline 1"
		bloodline_2.set_visible(true)
	else:
		bl_label.text = "Bloodline"
		bloodline_2.set_visible(false)
	
	if first_class == "Jack" or second_class == "Jack":
		bloodline_2.set_visible(false)
		bloodline_1.set_visible(false)
	else:
		bloodline_1.set_visible(true)

func selected_text():
	return self.get_item_text(self.get_selected())
