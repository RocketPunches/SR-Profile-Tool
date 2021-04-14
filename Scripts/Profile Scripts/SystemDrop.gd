extends VBoxContainer

"""
Itermediary class for handling basic communications between nodes that don't need
direct access to each other's data. Inludes references to all nodes in container 
to support any future expansions to the tool.
"""

onready var ui_elements = {
	"class1": get_node("Class1DropContainer/ClassDrop1"),
	"class2": get_node("Class2DropContainer/ClassDrop2"),
	"disc1": get_node("Class1DropContainer/DiscDrop1"),
	"disc2": get_node("Class2DropContainer/DiscDrop2"),
	"bloodline1": get_node("Bloodline1DropContainer/BloodlineDrop1"),
	"bloodline2": get_node("Bloodline2DropContainer/BloodlineDrop2"),
	"bltype1": get_node("Bloodline1DropContainer/BloodlineType1"),
	"bltype2": get_node("Bloodline2DropContainer/BloodlineType2"),
	}
	
onready var bloodline_label = get_node("Bloodline1DropContainer/Bloodline1Label")

func disable_menu(menu):
	ui_elements[menu].set_disabled(true)
	
func enable_menu(menu):
	ui_elements[menu].set_disabled(false)

func set_visibility(menu, state):
	ui_elements[menu].set_visible(state)

func set_selection(menu, index):
	ui_elements[menu].select(index)

func disable_menu_item(menu, index, state):
	ui_elements[menu].set_item_disabled(index, state)

func change_bl_label():
	if bloodline_label.text == "Bloodline":
		bloodline_label.text = "Bloodline 1"
	else:
		bloodline_label.text = "Bloodline"
		
		
