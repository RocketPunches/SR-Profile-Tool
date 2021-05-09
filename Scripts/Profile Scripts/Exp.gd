extends LineEdit

export(NodePath) var helper_path
export(NodePath) var timer_path

onready var stats_helper = get_node(helper_path)
onready var timer = get_node(timer_path)

onready var regex = RegEx.new()
onready var default_color = self.get("font_color")

var is_valid = true

func _ready():
	regex.compile("[^0-9]+")
	
	timer.connect("timeout", self, "_on_timeout")
		
func _on_timeout():
	if is_valid:
		OutputData.character_info["Experience"] = self.get_text()
		stats_helper.update_stats()
	else:
		stats_helper.reset_stats()


func _on_LineEdit_text_changed(new_text):
	
	timer.set_wait_time(2)
	timer.start()
	
	var matches = regex.search_all(new_text)
	if matches or self.text == "":
		is_valid = false
		self.add_color_override("font_color", Color.red)
	else:
		is_valid = true
		set("custom_colors/font_color", null)
		
