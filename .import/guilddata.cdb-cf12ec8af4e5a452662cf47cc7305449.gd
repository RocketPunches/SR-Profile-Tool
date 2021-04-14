extends Node

const CastleDB = preload("res://addons/thejustinwalsh.castledb/castledb_types.gd")

class Classes:

	const Ninjutsu := "Ninjutsu"
	const Genjutsu := "Genjutsu"
	const Taijutsu := "Taijutsu"
	const Bukijutsu := "Bukijutsu"
	const Scholar := "Scholar"
	const Jack := "Jack"
	const Bloodline := "Bloodline"
	const Medical := "Medical"
	const Performer := "Performer"
	const Puppeteer := "Puppeteer"
	const Tamer := "Tamer"

	class ClassesRow:
		var id := ""
		
		func _init(id = ""):
			self.id = id
	
	var all = [ClassesRow.new(Ninjutsu), ClassesRow.new(Genjutsu), ClassesRow.new(Taijutsu), ClassesRow.new(Bukijutsu), ClassesRow.new(Scholar), ClassesRow.new(Jack), ClassesRow.new(Bloodline), ClassesRow.new(Medical), ClassesRow.new(Performer), ClassesRow.new(Puppeteer), ClassesRow.new(Tamer)]
	var index = {Ninjutsu: 0, Genjutsu: 1, Taijutsu: 2, Bukijutsu: 3, Scholar: 4, Jack: 5, Bloodline: 6, Medical: 7, Performer: 8, Puppeteer: 9, Tamer: 10}
	
	func get(id:String) -> ClassesRow:
		if index.has(id):
			return all[index[id]]
		return null

	func get_index(idx:int) -> ClassesRow:
		if idx < all.size():
			return all[idx]
		return null

var classes := Classes.new()
