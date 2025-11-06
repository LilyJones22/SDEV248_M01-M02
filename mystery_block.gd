extends StaticBody2D

@export var item_scene: PackedScene
var hit = false

func on_player_hit():
	if hit:
		return
	hit = true
	
	if item_scene:
		var item = item_scene.instantiate()
		get_tree().current_scene.add_child(item)
		item.global_position = global_position + Vector2(0, -40)
		
	$Sprite2D.texture = preload("res://Art/png/normal block.png")


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		on_player_hit()
