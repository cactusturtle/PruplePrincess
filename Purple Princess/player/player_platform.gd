extends KinematicBody2D

export (int) var speed = 800
export (int) var jump_speed = -1800
export (int) var gravity = 4000

var state_machine
var velocity = Vector2.ZERO
var screensize

onready var weapon_equipped = false


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	screensize = get_viewport_rect().size
	#if get_parent().name == "level_1":
		#set_camera_limits()
	
	if !weapon_equipped:
		$torso/sword.hide()


func get_input():
	var current = state_machine.get_current_node()
	velocity.x = 0
	
	if Input.is_action_just_pressed("attack"):
		attack()
		return
	
	if Input.is_action_just_released("equip"):
		equip()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		$torso.scale.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$torso.scale.x = -1
	
	if velocity.length() == 0:
		state_machine.travel("idle")
	if velocity.length() > 0:
		state_machine.travel("walk")


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	
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
