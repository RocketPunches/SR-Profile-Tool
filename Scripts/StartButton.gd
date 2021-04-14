extends Button

"""
This class should handle more when other sections of the tool are added, for now
it just calls the UIController node's change_scene function
"""

func _on_Button_pressed():
	UIController.change_scene("res://Scenes/Profile_Core.tscn")
