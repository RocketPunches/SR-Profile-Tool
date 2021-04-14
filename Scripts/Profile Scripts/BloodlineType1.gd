extends OptionButton

export(NodePath) var bloodline_drop_path

onready var bloodline_drop = get_node(bloodline_drop_path)
onready var menu_data = ImportData.menu_data

func _ready():
	
	self.add_item("None")
	
	for list_item in menu_data["bloodlines_types"]["elements"]:
		self.add_item(list_item["element"])


func _on_BloodlineType1_item_selected(index):
	
	if bloodline_drop.is_disabled() == true:
		bloodline_drop.set_disabled(false)
		
	bloodline_drop.populate_dropdown(self.get_item_text(index))
