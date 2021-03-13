extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	# check if player is overlapping area
	var bodies = get_overlapping_bodies()
	var player_is_in = false
	# check if user is pressing e whle overlapping area if true emit signal to 
	# change the sprite appearance
	for bod in bodies:
		if bod.is_in_group("player"):
			player_is_in = true
			break
	if player_is_in and Input.is_action_just_released("interact"):
		Global.on_player_leaving_scene(self.name)
		#Global.goto_scene("res://levels/level2/level_2.tscn")
		print("TRYING TO LEAVE")


func _process(delta):
	get_input()
