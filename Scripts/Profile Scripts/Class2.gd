extends OptionButton

export(NodePath) var discipline_path

onready var disc_drop = get_node(discipline_path)

var menu_data = ImportData.menu_data

func _ready(): # Class 1 dropdown leads, no need to set indexes when data is the same
	
	# add none item for making sure user has consciously made a choice
	self.add_item("None")
	
	for list_item in menu_data["classes"]["elements"]:
		self.add_item(list_item["element"])


func _on_ClassDrop2_item_selected(index):
	
	if disc_drop.is_disabled(): # Enable discipline selection if disabled
		disc_drop.set_disabled(false)
		
	disc_drop.populate_dropdown(self.get_item_text(index))
	
	if index != 0 and self.is_item_disabled(0) != true:
		self.set_item_disabled(0, true)
	
	OutputData.character_info["Class 2"] = self.get_item_text(index)

func selected_text():
	return self.get_item_text(self.get_selected())
