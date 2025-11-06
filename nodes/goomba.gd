extends Area2D

var health = 1


			
func _physics_process(delta):
	if health == 0:
		queue_free()
			

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
