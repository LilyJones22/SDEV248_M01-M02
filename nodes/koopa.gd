extends Area2D

const CLOSED = preload("res://Art/png/enemy_2_in.png")
var health = 2

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
	if ground_check:
		ground_check.enabled = true
		
func turn_around():
	direction *= -1
	start_x = global_position.x
	distance_traveled = 0.0
	
	if wall_check:
		wall_check.position.x = abs(wall_check.position.x) * direction
	if ground_check:
		ground_check.position.x = abs(ground_check.position.x) * direction
		
func _physics_process(delta):
	if health == 0:
		queue_free()
		
	if health == 1:
		$Sprite2D.texture = CLOSED
		ground_check.enabled = false
		
	position.x += direction * speed * delta
	distance_traveled = abs(global_position.x - start_x)
	if distance_traveled >= patrol_distance:
		turn_around()
		
	if wall_check and wall_check.is_colliding():
		turn_around()
		
	if ground_check and not ground_check.is_colliding():
		turn_around()
			

func _on_area_entered(area):
	if area.is_in_group("player"):
		if area.has_blue:
			health = 0
		else:
			if area.is_on_floor() == true:
				area.take_damage()
			
			else:
				health -= 1
			
			
	if area.is_in_group("laser"):
		health = 0
	
