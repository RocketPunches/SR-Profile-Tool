extends VBoxContainer

"""
This class is responsible for the header of the profile creation section of the
tool, mainly changing the active (visible) section. The decision was made to simply
load all individual subscenes and hide them, instead of instancing them, because
it's easier to manage in code and there are not that many of them.
"""

onready var section_label = get_node("NavigationContainer/SectionLabel")
onready var left_button = get_node("NavigationContainer/LeftButton")
onready var right_button = get_node("NavigationContainer/RightButton")

# Stores references to the sections of the profile part of the tool.
# Normally I'd want to proceduralize the creation of this, or store it somehwere
# easier to update, but there's just not enough of them to warrant it.
# # New Entries: Increment indexs from 1 for easier comparison to length.
onready var sections_dir = {
	1: {"section_name": "Personal Data", "section_node": get_node("PersonalDataContainer")},
	2: {"section_name": "Physical Characteristics", "section_node": get_node("PhysCharContainer")},
	3: {"section_name": "Social and Peronality", "section_node": get_node("SocPerContainer")},
	4: {"section_name": "RP Systems", "section_node": get_node("RPSystemsContainer")},
	5: {"section_name": "Missions and Rewards", "section_node": get_node("MissionContainer")},
	6: {"section_name": "Unique Items and Inventory", "section_node": get_node("InventoryContainer")},
	7: {"section_name": "Finalize", "section_node": get_node("FinalizationContainer")},
}

# Kinda lazy int storage of index, start at 1 so sections_dir.size() doesn't need to be modified for comparison
var current_section = 1

func _ready():
	
	# Set all sections to invisible
	for index in sections_dir:
		sections_dir[index]["section_node"].visible = false
		#print(sections_dir[index]["section_name"] + " section disabled.")
	
	# Set NavCon label, set the first section visible, disable left button
	section_label.set_text(sections_dir[1]["section_name"])
	sections_dir[1]["section_node"].visible = true
	left_button.disabled = true

func _on_LeftButton_pressed():
	
	if current_section == 1: # Pure paranoia, almost certainly not necessary
		return 
	
	var new_section = current_section - 1
	
	# Activate right button, because moving left through sections
	# can only ever move away from the last section
	if right_button.disabled == true:
		right_button.disabled = false
	
	sections_dir[current_section]["section_node"].visible = false
	sections_dir[new_section]["section_node"].visible = true
	
	section_label.set_text(sections_dir[new_section]["section_name"]) # Set label
	
	if new_section == 1: # Disable left button if at the first profile page
		left_button.disabled = true
	
	current_section = new_section
	

func _on_RightButton_pressed(): # Basically the same as the first
	
	if current_section == sections_dir.size():
		return
	
	var new_section = current_section + 1
	
	# Activate left button, because moving right through sections
	# can only ever move away from the first section
	if left_button.disabled == true:
		left_button.disabled = false
		
	sections_dir[current_section]["section_node"].visible = false
	sections_dir[new_section]["section_node"].visible = true
	
	section_label.set_text(sections_dir[new_section]["section_name"]) # Set label
	
	if current_section == sections_dir.size(): # Disable right button if at last profile page
		right_button.disabled = true
	
	current_section = new_section
