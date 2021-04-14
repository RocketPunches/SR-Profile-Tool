extends HBoxContainer

var menu_data = ImportData.menu_data
onready var dropdown = get_node("OptionButton")

func _ready():
	
	# Add a Not Selected option so that a choice has to be registered
	dropdown.add_item("Not Selected")
	
	for element in menu_data["affiliations"]["elements"]:
		if element["element"] == "Custom":
			pass # Catch Custom and don't add it, remove when custom field implemented
		else:
			dropdown.add_item(element["element"])


func _on_OptionButton_item_selected(index):
	if index != 0:
		dropdown.set_item_disabled(0, true)
	OutputData.character_info["Affiliation"] = dropdown.get_item_text(index)
