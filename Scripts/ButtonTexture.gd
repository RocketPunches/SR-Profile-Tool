extends TextureButton

"""
Right now creates an ImageTexture from button Images and sets TextureButton's
textures based on that, modulating them to match the theme. Might only need to modulate
on scene change
"""

export (Image) var source_image

onready var button_stylebox = preload("res://Themes/Styles/button_stylebox.tres")

var tint_value

func _ready():
	var button_texture = ImageTexture.new()
	button_texture.create_from_image(source_image)
	
	tint_value = button_stylebox.bg_color
	
	self.texture_normal = button_texture
	self.modulate = Color(tint_value)
	
func update_image():
	pass
