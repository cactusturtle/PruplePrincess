extends KinematicBody2D

enum states {WALKING, WAITING, TALKING}
var state = states.WALKING

# For settinng animations
var state_machine
var move_speed = 100
var talking = ["talk"]

# For path following
export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0

var velocity = Vector2(move_speed, 0)

var has_crown


# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	#check if quest is completedand show npc crown if true
	if Global.quest_status == Global.QuestStatus.COMPLETED:
		has_crown = true
	
	if has_crown == true:
		$torso/crown.show()
	else:
		$torso/crown.hide()

# Called every frame
func _physics_process(delta):
	choose_action()
	
	var current = state_machine.get_current_node()
	
	if velocity.x > 0:
		$torso.scale.x = 1
	elif velocity.x < 0:
		$torso.scale.x = -1
	
	if velocity.length() > 0:
		state_machine.travel("walking")
	
	if current == "walking" and velocity.length() == 0:
		state_machine.travel("idle")
	
	velocity = move_and_slide(velocity)


func choose_action():
	
	velocity = Vector2.ZERO
	var current = state_machine.get_current_node()
	
	# If currently talking, do not move or change state.
	if current in talking:
		return
	
	var target
	match state:
		states.WALKING:
			if !patrol_path:
				return
			target = patrol_points[patrol_index]
			if position.distance_to(target) < 1:
				patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
				target = patrol_points[patrol_index]
				return
			velocity = (target - position).normalized() * move_speed
		
		states.WAITING:
			velocity = Vector2(0, 0)
		
		states.TALKING:
			if Global.quest_status == Global.QuestStatus.NOT_STARTED:
				$Label.text = "Please find my crown!"
			elif Global.quest_status == Global.QuestStatus.STARTED:
				$Label.text = "The monster outside has it!"
			else:
				$Label.text = "Thank you!"
			$Label.show()


func _on_IdleTimer_timeout():
	print("IdleTimer timeout")
	$Label.hide()
	$IdleTimer.stop()
	state = states.WALKING

"""
#for version 2 dialogue expansion
func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Fiona"
"""



func _on_InteractionArea2D_body_entered(body):
	if body.name == "Player":
		#if Input.is_action_just_pressed("interact"):
		print("player trying to talk to you")
		state = states.TALKING
		$IdleTimer.start()
