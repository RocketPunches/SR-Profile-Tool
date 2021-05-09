extends Node

"""
SINGLETON
This class handles collation of data for outputting the final profile code from
the tool. Other classes should send data to this class for storage, and update
that data whenever relevant signals are sent. Communication should be one way,
node to singleton, never singleton to node.

character_info key naming conventions: Full Name, Nickname, Age, Birthdate, Gender, 
Affiliation, Bloodline 1, Bloodline 2, Height, Chakra Materialization, Discipline 1, 
Discipline 2, Nindo, Outfit Description, Strength 1, Strength 2, Personality, 
Physical Description, Experience, Fear 1, Fear 2, Chakra Color, Class 1, Class 2, 
Discipline 1, Discipline 2, Affiliation

"""

var character_info = {}

var is_Jack = false
var is_Bloodline = false
var has_keystone = false
var has_DA = false

var body_rank = "D"
var chakra = 0
var stamina = 0

func _ready():
	pass

func stat_calc():
	var experience = int(character_info["Experience"])
	var rank_exp = 0
	
	for rank in ImportData.body_rank_data:
		if experience >= int(rank["xp_required"]) and int(rank["xp_required"]) > rank_exp:
			rank_exp = int(rank["xp_required"])
			body_rank = rank["body_rank"]
	
	chakra = _chakra_calc(body_rank)
	stamina = _stamina_calc(body_rank)
	
	character_info["Chakra"] = chakra
	character_info["Stamina"] = stamina
	character_info["Body Rank"] = body_rank

func _chakra_calc(rank):
	
	var experience = int(character_info["Experience"])
	
	var class1 = character_info["Class 1"]
	var class2 = character_info["Class 2"]
	
	var calculated_chakra
	
	for entry in ImportData.class_data[class1]["resources"]:
		if entry["rank"] == rank:
			calculated_chakra = int(entry["chakra"])
	
	for entry in ImportData.class_data[class2]["resources"]:
		if entry["rank"] == rank:
			calculated_chakra += int(entry["chakra"])
			
	for entry in ImportData.expansion_data:
		if experience >= int(entry["xp_total"]):
			calculated_chakra += int(entry["resource_value"])
	
	return calculated_chakra

func _stamina_calc(rank):
	
	var experience = int(character_info["Experience"])
	
	var class1 = character_info["Class 1"]
	var class2 = character_info["Class 2"]
	
	var calculated_stamina
	
	for entry in ImportData.class_data[class1]["resources"]:
		if entry["rank"] == rank:
			calculated_stamina = int(entry["stamina"])
	
	for entry in ImportData.class_data[class2]["resources"]:
		if entry["rank"] == rank:
			calculated_stamina += int(entry["stamina"])
			
	for entry in ImportData.expansion_data:
		if experience >= int(entry["xp_total"]):
			calculated_stamina += int(entry["resource_value"])
	
	return calculated_stamina

# This is extremely inelegant, but I don't want to deal with figuring out the database
# stuff I need for this when it's so likely to change. I'll clean it up after there's
# a working version of the tool

func format_profile():
	var final_string = ""
	
	var profile_header = (
		"[align=center][img=\"imgheight=500\"]YOUR IMAGE URL HERE[/img][/align]\n" +
		"[imgleft]https://i.imgur.com/1PRi5nG.png[/imgleft]\n" +
		"[imgright]https://i.imgur.com/1PRi5nG.png[/imgright]\n" +
		"[align=left][align=right][align=justify]\n")
	var personal_data = (
		"[size=18]▰[color=black]▰[/color]▰ PERSONAL DATA[/size]\n" + 
		"\n" +
		"[size=10][b]Full Name:[/b] {Full Name}" +
		"[b]Nickname:[/b] {Nickname}\n" +
		"[b]Age:[/b] {Age}\n" +
		"[b]Birthdate:[/b] {Birthdate}\n" +
		"[b]Gender:[/b] {Gender}\n" +
		"[/size]\n")
	var phys_char_1 = (
		"[size=18]▰[color=black]▰[/color]▰ PHYSICAL CHARACTERISTICS[/size]\n" +
		"\n" +
		"[size=10][b]Height:[/b] {Height}\n" + 
		"[b]Weight:[/b] {Weight}\n" +
		"\n" +
		"[b]Body Rank:[/b] {Body Rank}\n")
	var bloodline = ["[b]Bloodline:[/b] {Bloodline 1}", "[b]Bloodlines:[/b] {Bloodline 1} | {Bloodline 2}"]
	var phys_char_2 = (
		"\n" +
		"▰[color=black]▰[/color]▰ [b]Physical Description[/b]\n" +
		"{Physical Description}\n" +
		"\n" +
		"▰[color=black]▰[/color]▰ [b]Outfit Description[/b]\n" + 
		"{Outfit Description}" +
		"[/size]\n")
	var soc_per = (
		"[size=18]▰[color=black]▰[/color]▰ SOCIAL AND PERSONALITY[/size]" +
		"\n" +
		"[size=10][b]Affiliation:[/b] {Affiliation}\n" +
		"[b]Title:[/b] {Title}\n" +
		"\n" +
		"[b]Reputation[/b]\n" +
		"[spoiler]\n" + 
		"[b]Local Reputation:[/b] 0 Fame/Infamy\n" + 
		"[b]Global Reputation:[/b] 0 Fame/Infamy\n" + 
		"[/spoiler]\n" +
		"\n" +
		"[b]Personality:[/b]\n" +
		"{Personality}\n" +
		"\n" +
		"[b]Background:[/b]\n" +
		"{Background}\n" +
		"\n" +
		"[b]Story Missions[/b]\n" +
		"[spoiler]\n" +
		"(Story relevant mission links and info goes here.)\n" +
		"[/spoiler]\n" +
		"\n" +
		"[b]Strengths:[/b]\n" +
		"• {Strength 1}\n" +
		"• {Strength 2}\n" +
		"[b]Weaknesses:[/b]\n" +
		"• {Weakness 1}\n" +
		"• {Weakness 2}\n" +
		"[b]Fears:[/b]\n" +
		"• {Fear 1}\n" +
		"• {Fear 2}\n" +
		"[/size]\n")
	var class_stats = (
		"[size=18]▰[color=black]▰[/color]▰ CLASSES AND STATS[/size]\n" +
		"\n" +
		"[size=10][b]First Class:[/b] {Class 1}\n" +
		"[color=white]▱▰▱ [/color][u]{Discipline 1}[/u] → [i]Description[/i]\n" +
		"[b]Second Class:[/b] {Class 2}\n" +
		"[color=white]▱▰▱ [/color][u]{Discipline 2}[/u] → [i]Description[/i]\n" +
		"[color=white]▱▰▱ [/color][u]Cross Class or Specialization:[/u] → [i]Description[/i]\n" +
		"\n" +
		"[quote=\"Cross Class Technique\"]Cross Class Tech[/quote]\n" +
		"\n" +
		"[b]Chakra Pool:[/b] {Chakra}\n" +
		"[b]Stamina Pool:[/b] {Stamina}\n" +
		"[b]Chakra Element:[/b]\n" +
		"[b]Chakra Color:[/b] {Chakra Color}\n" +
		"\n" +
		"▰▰▰ [b]Stats:[/b]\n" +
		"• Strength ► 0\n" +
		"[color=white]→[/color]→ N/A\n" +
		"• Speed ► 0\n" +
		"[color=white]→[/color]→ N/A\n" +
		"• Agility ► 0\n" +
		"[color=white]→[/color]→ N/A\n" +
		"• Endurance ► 0\n" +
		"[color=white]→[/color]→ N/A\n" +
		"\n" +
		"▰▰▰ [b]Personal Attributes:[/b]\n" +
		"• [b]PA Name[/b] | PA DESCRIPTION\n" +
		"\n" +
		"▰▰▰ [b]Traits and Abilities:[/b]\n" +
		"[i]Bloodline[/i]\n" +
		"•\n" +
		"[/size]\n")
	var missions_rewards = (
		"[size=18]▰[color=black]▰[/color]▰ MISSIONS AND REWARDS[/size]\n" +
		"\n" +
		"[size=10][b]XP:[/b] {Experience}\n" +
		"[b]Ryo:[/b] 両0\n" +
		"\n" +
		"[b]Shinobi Missions Complete:[/b]\n" +
		"D Rank: 0\n" +
		"C Rank: 0\n" +
		"B Rank: 0\n" +
		"A Rank: 0\n" +
		"S Rank: 0\n" +
		"\n" +
		"[b]Crafting Trees[/b]\n" +
		"• {First Tree Here} || → {Current Title}\n" +
		"\n" +
		"[b]Crafting Profession Missions Complete:[/b]\n" +
		"D Rank: 0\n" +
		"C Rank: 0\n" +
		"B Rank: 0\n" +
		"A Rank: 0\n" +
		"S Rank: 0\n" +
		"\n" +
		"[b]Profession Titles[/b]\n" +
		"• {First Tree Here} || → {Current Title}\n" +
		"\n" +
		"[b]Profession Missions Complete:[/b]\n" +
		"D Rank: 0\n" +
		"C Rank: 0\n" +
		"B Rank: 0\n" +
		"A Rank: 0\n" +
		"S Rank: 0\n" +
		"\n" +
		"Missions Claim: [ [url=YOUR CLAIM URL]x[/url] ]\n" +
		"\n" +
		"[b]Arc and Event Rewards:[/b]\n" +
		"•\n" +
		"[/size]\n")
	var possessions_inventory = (
		"[size=18]▰[color=black]▰[/color]▰ UNIQUE POSSESSIONS AND INVENTORY[/size]\n" +
		"[size=10]\n" +
		"[b]Summoning Contract:[/b]\n" +
		"[b]Forbidden Seals:[/b]\n" +
		"[b]Biju:[/b]\n" +
		"[b]Golden Dragon Mark:[/b]\n" +
		"[b]Sage Modes:[/b]\n" +
		"\n" +
		"[b]General Inventory[/b]\n" +
		"•\n" +
		"•\n" +
		"•\n" +
		"•\n" +
		"•\n" +
		"•\n" +
		"[/size]\n")
	var techniques = (
		"[size=18]▰[color=black]▰[/color]▰ TECHNIQUES[/size]\n" +
		"\n" +
		"[size=10][b]Limitations:[/b]\n" +
		"• Ninjutsu | 00 / 00\n" +
		"• Genjutsu | 00 / 00\n" +
		"• Iryojutsu | 00 / 00\n" +
		"• Kugutsu | 00 / 00\n" +
		"• Taijutsu Styles | 00 / 00\n" +
		"• Bukijutsu Styles | 00 / 00\n" +
		"\n" +
		"▰▰▰ [b]Maruton:[/b]\n" +
		"• Kai | Rank X | Default\n" +
		"• Henge no Jutsu | Rank E | Default\n" +
		"• Bunshin no Jutsu | Rank E | Default\n" +
		"• Substitution Technique | Rank E | Default\n" +
		"• Art of Walking on Water | D Rank | Default\n" +
		"• Art of Walking on Walls | D Rank | Default\n" +
		"[/size]\n" +
		"[size=10]▰▰▰ [b]Ninjutsu Type[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10] ▰▰▰ [b]Bloodline[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10] ▰▰▰ [b]Iryojutsu[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10] ▰▰▰ [b]Fuuinjutsu[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10] ▰▰▰ [b]Kugutsu[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10]▰▰▰ [b]Genjutsu[/b] 00/00\n" +
		"\n" +
		"[i]Illusory[/i]\n" +
		"•\n" +
		"\n" +
		"[i]Enchantment[/i]\n" +
		"•\n" +
		"\n" +
		"[i]Instance[/i]\n" +
		"•\n" +
		"\n" +
		"[i]Chain[/i]\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10]▰▰▰ [b]Taijutsu[/b] 00/00\n" +
		"•\n" +
		"[/size]\n" +
		"[size=10]▰▰▰ [b]Bukijutsu[/b] 00/00\n" +
		"•\n" +
		"[/size]\n")
	
	final_string = profile_header.format(character_info)
	final_string += personal_data.format(character_info)
	final_string += phys_char_1.format(character_info)
	
	if has_DA:
		final_string += bloodline[1].format(character_info)
	else:
		final_string += bloodline[0].format(character_info)
	
	final_string += phys_char_2.format(character_info)
	final_string += soc_per.format(character_info)
	final_string += class_stats.format(character_info)
	final_string += missions_rewards.format(character_info)
	
	return final_string

func populate_profile_string():
	pass
