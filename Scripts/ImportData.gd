extends Node

"""
SINGLETON
This class handles the CastleDB file for the tool. It's job is purely breaking
the CastleDB file down into more manageable chunks to make accessing the sheets
easier and simplify loops in the processing scripts
"""

var menu_data = {}
var class_data = {}
var body_rank_data = {}
var expansion_data = {}
var profile_string = {}

func _ready():
	var data_read = File.new()
	data_read.open( "res://guilddata.cdb", File.READ )
	var data_cdb = parse_json( data_read.get_as_text() )
	data_read.close()

	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "menu_options":
			for entry in sheet["lines"]:
				var new_entry = entry.duplicate()
				new_entry.erase("id")
				menu_data[ entry["id"] ] = new_entry

	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "classes":
			for entry in sheet["lines"]:
				var new_entry = entry.duplicate()
				new_entry.erase("id")
				class_data[ entry["id"] ] = new_entry
				
	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "experience":
			for entry in sheet["lines"]:
				body_rank_data = entry["body_rank_value"]
	
	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "experience":
			for entry in sheet["lines"]:
				expansion_data = entry["expansion_value"]
