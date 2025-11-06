extends Area2D

@export var speed := 550
var direction = Vector2.RIGHT

const PINK_TEX = preload("res://Art/png/laser_pink.png")
const BLUE_TEX = preload("res://Art/png/laser_blue.png")

func _process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.health = 0
