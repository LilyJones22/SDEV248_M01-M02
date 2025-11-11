extends CharacterBody2D

var speed = 400
var jump_force = -600
var gravity = 1200

signal lives_changed(new_lives)
signal coins_changed(new_coins)

var lives = 3
var coins = 0

var has_yellow = false
var has_pink = false
var has_blue = false

@export var bullet_scene: PackedScene
@export var fire_offset:= Vector2(16, 0)
@export var fire_rate:= 0.2
var can_fire = true

const REG_TEXTURE = preload("res://Art/png/main_character.png")
const YELLOW_TEXTURE = preload("res://Art/png/main_character_yellow.png")
const PINK_TEXTURE = preload("res://Art/png/main_character_pink.png")
const BLUE_TEXTURE = preload("res://Art/png/main_character_blue.png")





func fire_bullet():
	if not can_fire:
		return
	can_fire = false
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(-fire_offset.x, fire_offset.y)
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

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
		
	if Input.is_action_just_pressed("shoot") and has_pink:
		fire_bullet()
	 
func take_damage():
	if has_blue:
		pass
	elif has_pink:
		has_pink = false
	elif has_yellow:
		has_yellow = false
		scale = Vector2(1.0, 1.0)
	else:
		lives -= 1
		emit_signal("lives_changed", lives)
	
func collect_coin():
	coins += 1
	emit_signal("coins_changed", coins)
	
func collect_data(data): # gain powerup
	data.apply(self)
	
func color_check():
	if has_blue:
		$Sprite2D.texture = BLUE_TEXTURE
	elif has_pink:
		$Sprite2D.texture = PINK_TEXTURE
	elif has_yellow:
		$Sprite2D.texture = YELLOW_TEXTURE
	else:
		$Sprite2D.texture = REG_TEXTURE

	
	
func _physics_process(delta):
	get_input(delta)
	move_and_slide()
	color_check()

	if velocity.y < 0 and $Ray.is_colliding():
		var collider = $Ray.get_collider()
		
		if collider.is_in_group("blocks"):
			collider.on_player_hit()
		elif collider.get_parent() and collider.get_parent().is_in_group("blocks"):
			collider.get_parent().on_player_hit()



func _on_out_of_bounds_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
		body.global_position = $"../Spawn".global_position
