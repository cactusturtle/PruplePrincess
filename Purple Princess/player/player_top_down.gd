extends KinematicBody2D


var state_machine
var move_speed = 150
var velocity = Vector2.ZERO
onready var weapon_equipped = false
var screensize


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	screensize = get_viewport_rect().size
	#if get_parent().name == "level_1":
		#set_camera_limits()
	
	if !weapon_equipped:
		$torso/sword.hide()


func get_input():
	
	var current = state_machine.get_current_node()
	
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		attack()
		return
	
	if Input.is_action_just_released("equip"):
		equip()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$torso.scale.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$torso.scale.x = -1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	velocity = velocity.normalized() * move_speed
	
	if velocity.length() == 0:
		state_machine.travel("idle")
	if velocity.length() > 0:
		state_machine.travel("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	velocity = move_and_slide(velocity * move_speed * delta).normalized()
	
	#position.x = clamp(position.x, 0, screensize.x)
	#position.y = clamp(position.y, 0, screensize.y)


func attack():
	if weapon_equipped == true:
		print("ATTACK")
		state_machine.travel("attack")


func equip():
	if weapon_equipped == false:
		$torso/sword.show()
		weapon_equipped = true
	elif weapon_equipped == true:
		$torso/sword.hide()
		weapon_equipped = false

"""
func set_camera_limits():
	var map_limits = get_node("../TileMap").get_used_rect()
	var map_cellsize = get_node("../TileMap").cell_size
	$Camera2D.limit_left = round(map_limits.position.x * map_cellsize.x)
	$Camera2D.limit_right = round(map_limits.end.x * map_cellsize.x)
	$Camera2D.limit_top = round(map_limits.position.y * map_cellsize.y)
	$Camera2D.limit_bottom = round(map_limits.end.y * map_cellsize.y)
"""
