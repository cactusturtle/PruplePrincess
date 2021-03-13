extends Node


# Declare member variables here. Examples:
enum QuestStatus {NOT_STARTED, STARTED, COMPLETED}
var quest_status = QuestStatus.NOT_STARTED
var current_scene = null

var travel_dictionary = {
	inner_castle_one = {
		"name" : "inner_castle_one",
		"in_scene" : "level_1",
		"going_to" : "res://levels/level2/level_2.tscn",
		"new_player_position" : Vector2(640, 320)
	},
	outer_castle_one = {
		"name" : "outer_castle_one",
		"in_scene" : "level_2",
		"going_to" : "res://levels/level1/level_1.tscn",
		"new_player_position" : Vector2(320, 140)
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	for door in get_tree().get_nodes_in_group("doors"):
		var door_name = door.connect("player_leaving", self, "_on_Door_player_leaving", [name])
		print(door_name)


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	current_scene.free()
	#current_scene.queue_free() # testing code
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	
	
	#testing out if we move receiver down here if itll work a second time
	# TEST SUCCESSFUL
	# Later use this one only when loading up from start scene!!
	for door in get_tree().get_nodes_in_group("doors"):
		var door_name = door.connect("player_leaving", self, "_on_Door_player_leaving", [name])
		print(door_name)


func on_player_leaving_scene(name):
	print(name)
	if travel_dictionary.has(name):
		var find_me = name
		name = null
		var new_path = Global.travel_dictionary[find_me]["going_to"]
		goto_scene(new_path)
