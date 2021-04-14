extends Node

"""
SINGLETON
This class handles collation of data for outputting the final profile code from
the tool. Other classes should send data to this class for storage, and update
that data whenever relevant signals are sent. Communication should be one way,
node to singleton, never singleton to node.
"""

var character_info = {}

var user_class_1
var user_class_2
var user_discipline_1
var user_discipline_2

var is_Jack = false
var is_Bloodline = false
var has_keystone = false
var has_DA = false

func _ready():
	pass
