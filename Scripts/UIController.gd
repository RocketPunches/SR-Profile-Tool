extends Node

"""DEPRICATED - REMOVE FROM FINAL - DISTRIBUTE TO SUB FILES"""

export(NodePath) var class_dropdown_1_path
export(NodePath) var class_dropdown_2_path
export(NodePath) var discipline_dropdown_1_path
export(NodePath) var discipline_dropdown_2_path
export(NodePath) var bloodline_type_1_path
export(NodePath) var bloodline_type_2_path
export(NodePath) var bloodline_name_1_path
export(NodePath) var bloodline_name_2_path
export(NodePath) var bloodline_container_2_path
export(NodePath) var bloodline_lable_1_path

# passing off data from ImportData to make reference less cumbersome
onready var menu_data = ImportData.menu_data
onready var class_data = ImportData.class_data

# pass off NodePath data to simplify code, 
# refactored from descriptive names to be shorter because code was unreadable
# get_node name is a better representation of what is being referenced
onready var class_1 = get_node(class_dropdown_1_path)
onready var class_2 = get_node(class_dropdown_2_path)
onready var discipline_1 = get_node(discipline_dropdown_1_path)
onready var discipline_2 = get_node(discipline_dropdown_2_path)
onready var bl_type_1 = get_node(bloodline_type_1_path)
onready var bl_type_2 = get_node(bloodline_type_2_path)
onready var bl_name_1 = get_node(bloodline_name_1_path)
onready var bl_name_2 = get_node(bloodline_name_2_path)
onready var bl_container_2 = get_node(bloodline_container_2_path)
onready var bl_lable_1 = get_node(bloodline_lable_1_path)

var bloodline_index                # index of bloodline class in the dropdown
var jack_index                     # index of jack class in the dropdown
onready var has_key = false        # whether the user has a keystone discipline
onready var has_DA = false         # whether user has Dual Ancestry discipline
onready var both_class_set = false # boolean for tracking if both classes are set

func _ready():
	
	# set user output data's info as part of forcing the user to make a class choice
	OutputData.user_class_1 = "None"
	OutputData.user_class_2 = "None"
	
	# populate class dropdowns with class names from menu_data via function to save code
	populate_class_dropdown(class_1)
	populate_class_dropdown(class_2)
	
	# connections
	class_1.connect("item_selected", self, "on_class1_selected")
	class_2.connect("item_selected", self, "on_class2_selected")
	discipline_1.connect("item_selected", self, "on_discipline1_selected")
	discipline_2.connect("item_selected", self, "on_discipline2_selected")

# executes pop dropdown data on class dropdown menu passed to it
func populate_class_dropdown(dropdown):
	
	# store the current index value of the dropdown element being addded
	# starts at 1 to skip the "None" element
	var index = 1
	
	# add none item for making sure user has consciously made a choice
	dropdown.add_item("None")
	
	# loop through the classes section of menu data to find the class names
	# add them to the appropriate dropdown, log the index if 
	for list_item in menu_data["classes"]["elements"]:
		dropdown.add_item(list_item["element"])
		if list_item["element"] == "Bloodline":
			bloodline_index = index
		elif list_item["element"] == "Jack":
			jack_index = index
		index += 1

# sets user class choice, enables other menu items
func on_class1_selected(id):
	
	OutputData.is_Jack = false
	OutputData.is_Bloodline = false
	
	# enable second class dropdown only after user selects their first class,
	# so the program can catch class incompatibilities, disable if "None" is selected
	# reenable disabled elements if necessary
	if class_1.get_item_text(id) == "None":
		class_2.disabled = true
	else:
		class_2.disabled = false
	
	# # Logged for cleanup, removal of discipline2.is_visible
	# # CleanRefID1
	if OutputData.user_class_2 != "None" and discipline_2.disabled == true and discipline_2.is_visible():
		discipline_2.disabled = false
		
	# set them both back to enabled, the match will catch and disable them
	class_2.set_item_disabled(bloodline_index, false)
	class_2.set_item_disabled(jack_index, false)
	
	# check the value of the selected text of the dropdown depending on the value of id
	# disable either jack or bloodline in class 2 if selected for class 1
	# # Logged for compartmentalization
	# # CompRefID1
	match class_1.get_item_text(id):
		"Bloodline":
			OutputData.is_Bloodline = true
			if class_2.get_selected() == jack_index:
				class_2.select(1)
				populate_discipline(class_2.get_item_text(1), 2)
			class_2.set_item_disabled(jack_index, true)
		"Jack":
			OutputData.is_Jack = true
			if class_2.get_selected() == bloodline_index:
				class_2.select(1)
				populate_discipline(class_2.get_item_text(1), 2)
			class_2.set_item_disabled(bloodline_index, true)
	
	if class_2.get_selected() == jack_index:
		OutputData.is_Jack = true
	elif class_2.get_selected() == bloodline_index:
		OutputData.is_Bloodline = true
	
	# set OutputData value and log it for checking.
	OutputData.user_class_1 = class_1.get_item_text(id)
	
	populate_discipline(OutputData.user_class_1, 1)
	
	if not discipline_1.is_visible():
		discipline_1.set_visible(true)
		
	set_bloodline_menu()

func on_class2_selected(id):
	
	both_class_set = true
	
	OutputData.user_class_2 = class_2.get_item_text(id)
	
	populate_discipline(OutputData.user_class_2, 2)
	
	match class_2.get_item_text(id):
		"Bloodline":
			OutputData.is_Bloodline = true
		"Jack":
			OutputData.is_Jack = true
	
	if class_1.get_selected() != jack_index and class_2.get_selected() != jack_index:
		OutputData.is_Jack = false
	
	if class_1.get_selected() != bloodline_index and class_2.get_selected() != bloodline_index:
		OutputData.is_Bloodline = false
	
	if not discipline_2.is_visible():
		discipline_2.set_visible(true)
		
	bl_type_1.disabled = false
	bl_name_1.disabled = false
	set_bloodline_menu()
		
func on_discipline1_selected(id):
	OutputData.user_discipline_1 = discipline_1.get_item_text(id)
	
	has_key = false
	has_DA = false
	
	for item in range(discipline_2.get_item_count()):
		if discipline_2.is_item_disabled(item):
				discipline_2.set_item_disabled(item, false)
	
	compare_disciplines()
	
	if check_keystone(OutputData.user_discipline_1):
		has_key = true
		if check_keystone(get_selected_text(discipline_2)):
			discipline_2.set_item_disabled(discipline_2.get_selected(), true)
			if discipline_2.get_selected() == 0 or discipline_2.get_selected() == 2:
				OutputData.user_discipline_2 = discipline_2.get_item_text(1)
				discipline_2.select(1)
				has_DA = check_dual_ancestry(OutputData.user_class_2)
			else:
				OutputData.user_discipline_2 = discipline_2.get_item_text(0)
				discipline_2.select(0)
	elif check_keystone(OutputData.user_discipline_2):
		has_key = true
	
	if check_dual_ancestry(OutputData.user_discipline_1):
		has_DA = true
	elif check_dual_ancestry(OutputData.user_discipline_2):
		has_DA = true
		
	set_bloodline_menu()
	print("discipline 1 select DA: " + str(has_DA))
	
func on_discipline2_selected(id):
	OutputData.user_discipline_2 = discipline_2.get_item_text(id)
	
	if check_keystone(OutputData.user_discipline_2):
		has_key = true
	elif not check_keystone(get_selected_text(discipline_1)):
		has_key = false
		
	if check_dual_ancestry(OutputData.user_discipline_2):
		has_DA = true
	elif not check_dual_ancestry(get_selected_text(discipline_1)):
		has_DA = false
		
	print("discipline 2 select DA: " + str(has_DA))

# populate discipline dropdowns with discipline names based on selected class
# !!!! SUSPECT DUAL ANCESTRY BUG LIVES HERE !!!
# # Logged for Compartmentalization
# # CompRefID2
func populate_discipline(class_id, dropdown_id):
	
	var index = 0
	
	match dropdown_id:
		1:
			if class_id == "None":
				discipline_1.disabled = true
				discipline_2.disabled = true
			else:
				discipline_1.clear()
				
				for item in range(discipline_2.get_item_count()):
					if discipline_2.is_item_disabled(item):
						discipline_2.set_item_disabled(item, false)
				
				for discipline in class_data[class_id]["disciplines"]:
					discipline_1.add_item(discipline["discipline_name"])
					
				OutputData.user_discipline_1 = discipline_1.get_item_text(0)
				
				if check_keystone(OutputData.user_discipline_1) and check_keystone(get_selected_text(discipline_2)):
					discipline_2.set_item_disabled(discipline_2.get_selected(), true)
					if discipline_2.get_selected() == 0 or discipline_2.get_selected() == 2:
						OutputData.user_discipline_2 = discipline_2.get_item_text(1)
						discipline_2.select(1)
						has_DA = check_dual_ancestry(OutputData.user_class_2) # !!!! BUG HERE
					else:
						OutputData.user_discipline_2 = discipline_2.get_item_text(0)
						discipline_2.select(0)
				else:
					has_key = check_keystone(OutputData.user_discipline_1)
					
				compare_disciplines()
					
				if discipline_1.disabled == true:
					discipline_1.disabled = false
				
				if check_dual_ancestry(OutputData.user_discipline_1):
					has_DA = true
				elif check_dual_ancestry(OutputData.user_discipline_2):
					has_DA = true
				
				print("populate discipline DA 1: " + str(has_DA))
				set_bloodline_menu()
		2:
			if class_id == "None":
				discipline_2.disabled = true
			else:
				discipline_2.clear()
				
				for discipline in class_data[class_id]["disciplines"]:
					discipline_2.add_item(discipline["discipline_name"])
					if check_keystone(discipline["discipline_name"]) and has_key:
						discipline_2.set_item_disabled(index, true)
					index += 1
				
				compare_disciplines()
				
				if check_keystone(discipline_2.get_item_text(0)) and has_key:
					OutputData.user_discipline_2 = discipline_2.get_item_text(1)
					discipline_2.select(1)
				else:
					OutputData.user_discipline_2 = discipline_2.get_item_text(0)
						
				if not check_keystone(get_selected_text(discipline_1)):
					has_key = check_keystone(OutputData.user_discipline_2)
					
				if discipline_2.disabled == true:
					discipline_2.disabled = false
				
				print("poupulate discipline 2 DA: " + str(has_DA))
				set_bloodline_menu()

# moved discipline validity check to its own function to reduce clutter
# in populate_discipline(), checks discipline name against known disqualifiers
func check_keystone(discipline_name):
	
	# # Logged for cleanup
	# # CleanRefID3
	match discipline_name:
		"Genius Keystone":
			return true
		"Brawler":
			return true
		"Heritage Keystone":
			return true
		"Expert":
			return true
		"Maladies Physician":
			return true
			
	return false

func check_dual_ancestry(discipline_name):
	if discipline_name == "Dual Ancestry":
		return true
	else:
		return false
		
func get_selected_text(dropdown):
	return dropdown.get_item_text(dropdown.get_selected())
	
func compare_disciplines():
	if get_selected_text(discipline_1) == get_selected_text(discipline_2):
		var temp_index = discipline_1.get_selected()
		discipline_2.set_item_disabled(temp_index, true)
		if discipline_2.get_selected() == 0 or discipline_2.get_selected() == 2:
			OutputData.user_discipline_2 = discipline_2.get_item_text(1)
			discipline_2.select(1)
		else:
			OutputData.user_discipline_2 = discipline_2.get_item_text(0)
			discipline_2.select(0)

func set_bloodline_menu():
		
	print("set_bloodline_menu called")
	print("has_DA's value was " + str(has_DA))
	
	if both_class_set:
		if OutputData.is_Jack:
			bl_container_2.set_visible(false)
			bl_type_1.disabled = true
			bl_name_1.disabled = true
		elif OutputData.is_Bloodline:
			bl_name_1.disabled = false
			bl_type_1.disabled = false
	
		bl_container_2.set_visible(has_DA)
		
		
		
