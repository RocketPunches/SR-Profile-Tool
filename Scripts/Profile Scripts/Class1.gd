extends OptionButton

"""
The class menus are set up as leader -> follower. Class 1 should always override the
status of the other two classes. I.E. if Jack or Bloodline is selected here, the
other two classes should change to reflect viable selections. As disciplines are
also subservient to class selections, this script should supercede their
leader -> follower relationship.
"""

export(NodePath) var discipline_1_path
export(NodePath) var discipline_2_path
export(NodePath) var class_2_path

onready var discipline_1 = get_node(discipline_1_path)
onready var discipline_2 = get_node(discipline_2_path)
onready var class_2 = get_node(class_2_path)

onready var menu_data = ImportData.menu_data
onready var is_Bloodline = OutputData.is_Bloodline
onready var is_Jack = OutputData.is_Jack

var bloodline_index
var jack_index

func _ready():
	var index = 1 # start at 1 to skip None
	
	# add none item for making sure user has consciously made a choice
	self.add_item("None")
	
	# loop through the classes section of menu data to find the class names
	# add them to the appropriate dropdown, log the index if 
	for list_item in menu_data["classes"]["elements"]:
		self.add_item(list_item["element"])
		if list_item["element"] == "Bloodline":
			bloodline_index = index
		elif list_item["element"] == "Jack":
			jack_index = index
		index += 1


func _on_ClassDrop1_item_selected(index):
	
	if discipline_1.is_disabled(): # Enable discipline selection if disabled
		discipline_1.set_disabled(false)
		
	discipline_1.populate_dropdown(self.get_item_text(index))
	
	# Disable None option when changed away from, as every character must have 2 classes
	if index != 0 and self.is_item_disabled(0) != true:
		self.set_item_disabled(0, true)
	
	# Check incoming index against Bloodline and Jack
	if bloodline_index == index:
		
		is_Bloodline = true
		is_Jack = false
		
		class_2.set_item_disabled(bloodline_index, false)
		class_2.set_item_disabled(jack_index, true)
		
		var other_selection = class_2.get_selected()
		
		if other_selection == jack_index:
			class_2.select(1)
			OutputData.character_info["Class 2"] = class_2.get_item_text(1)
			discipline_2.populate_dropdown(class_2.get_item_text(1))
		
	elif jack_index == index:
		
		is_Bloodline = false
		is_Jack = true
		
		class_2.set_item_disabled(bloodline_index, true)
		class_2.set_item_disabled(jack_index, false)
		
		var other_selection = class_2.get_selected()
		
		if other_selection == bloodline_index:
			class_2.select(1)
			OutputData.character_info["Class 2"] = class_2.get_item_text(1)
			discipline_2.populate_dropdown(class_2.get_item_text(1))
		
	else:
		
		is_Bloodline = false
		is_Jack = false
		
		class_2.set_item_disabled(bloodline_index, false)
		class_2.set_item_disabled(jack_index, false)
	
	OutputData.character_info["Class 1"] = self.get_item_text(index)

func selected_text():
	return self.get_item_text(self.get_selected())
	
