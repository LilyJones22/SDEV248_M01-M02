extends CharacterBody2D

const CLOSED = preload("res://Art/png/enemy_2_in.png")
var health = 2
var patrol_ready = false
var is_turning = false

@export var speed: float = 40.0
@export var patrol_distance: float = 200.0

@onready var sprite:= $Sprite2D
@onready var wall_check:= $WallCheck
@onready var ground_check:= $GroundCheck

var direction: int = -1
var distance_traveled: float = 0.0
var start_x: float

func _ready():
	start_x = global_position.x
	if wall_check:
		wall_check.enabled = true
	call_deferred("set_ready_to_patrol")
	
func set_ready_to_patrol():
	patrol_ready = true
		
func turn_around():
	if is_turning:
		return
		
	is_turning = true
	$TurnTimer.start()
	
	direction *= -1
	start_x = global_position.x
	distance_traveled = 0.0
	velocity.x = 0
	
	if wall_check:
		wall_check.position.x = abs(wall_check.position.x) * direction
		wall_check.target_position.x = abs(wall_check.target_position.x) * direction
	if ground_check:
		ground_check.position.x = abs(ground_check.position.x) * direction
		var shape_node = ground_check.get_child(0)
		shape_node.position.x = abs(shape_node.position.x) * direction
		
func _physics_process(delta):
	if health == 0:
		queue_free()
		
	if health == 1:
		$Sprite2D.texture = CLOSED
		$GroundCheck.hide()
		
			# Apply gravity so they stay grounded
	if not is_on_floor():
		velocity.y += 800 * delta  # adjust as needed for your scene
	else:
		velocity.y = 0
		
# Horizontal movement
	if not is_turning:
		velocity.x = direction * speed
	
	move_and_slide()
	
	# Patrol logic
	if patrol_ready and not is_turning:
		distance_traveled = abs(global_position.x - start_x)
		if distance_traveled >= patrol_distance:
			turn_around()
		elif wall_check and wall_check.is_colliding():
			turn_around()
		elif is_on_floor() and ground_check and not ground_check.get_overlapping_bodies().is_empty():
			turn_around()
				



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.has_blue:
			health = 0
		else:
			if body.is_on_floor() == true:
				body.take_damage()
			
			else:
				health -= 1
			
			
	if body.is_in_group("laser"):
		health = 0


func _on_turn_timer_timeout():
	is_turning = false
