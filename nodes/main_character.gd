extends CharacterBody2D

var speed = 400
var jump_force = -600
var gravity = 1200

func get_input(delta):
	var input_direction = 0  # left = -1, right = 1, none = 0

	if Input.is_action_pressed("right"):
		input_direction += 1
	if Input.is_action_pressed("left"):
		input_direction -= 1
		
	velocity.x = input_direction * speed

	# applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	 

		
	
func _physics_process(delta):
	get_input(delta)
	move_and_slide()
