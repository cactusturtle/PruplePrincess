extends KinematicBody2D


export (NodePath) var patrol_path
export (int) var gravity = 4000
var state_machine
var move_speed = 100
var patrol_points
var patrol_index = 0
var velocity = Vector2(move_speed, 0)

onready var hp = 100


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()
	
	if Global.quest_status == Global.QuestStatus.COMPLETED:
		$body/crown.hide()


func _physics_process(delta):
	choose_action()
	#var current = state_machine.get_current_node()
	
	if velocity.x > 0:
		$body.scale.x = 1
	elif velocity.x < 0:
		$body.scale.x = -1
	
	if velocity.length() > 0:
		state_machine.travel("idle 2")
	
	if state_machine.get_current_node() == "idle 2" and velocity.length() == 0:
		state_machine.travel("idle")
	
	velocity = move_and_slide(velocity)
	#velocity.y += gravity * delta
	#velocity = move_and_slide(velocity, Vector2.UP).normalized() * delta



func choose_action():
	velocity = Vector2.ZERO
	
	var current = state_machine.get_current_node()
	
	if !patrol_path:
		return
	
	if hp <=0:
		if Global.quest_status != Global.QuestStatus.COMPLETED:
			Global.quest_status = Global.QuestStatus.COMPLETED
		self.queue_free()
	
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - position).normalized() * move_speed
	#velocity = move_and_slide(velocity)
	


func _on_painarea_body_entered(body):
	pass # Replace with function body.


func _on_painarea_area_entered(area):
	if area.name == "sword":
		print("hit by a sword")
		hp -= 10
		print(hp)
