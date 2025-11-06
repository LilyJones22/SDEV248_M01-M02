extends Node
# STARMAN



func apply(player):
	player.has_blue = true
	
	await get_tree().create_timer(5).timeout
	player.has_blue = false
