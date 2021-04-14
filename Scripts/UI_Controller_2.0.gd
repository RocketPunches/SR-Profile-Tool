extends Control

"""
SINGLETON
This class should handle transition between sections of the tool by instancing them
into the 3D_Core. It also stores references to things needed for management of UI elements
such as the tool's main theme so that colors can be changed while the tool is running
"""

export (PackedScene) var main_menu
export (Theme) var main_theme

var current_scene

func _ready():
	var scene_instance = main_menu.instance()
	add_child(scene_instance)
	current_scene = scene_instance

func change_scene(target_scene):
	var new_scene = load(target_scene).instance()
	remove_child(current_scene)
	add_child(new_scene)
