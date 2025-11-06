extends CanvasLayer

func _ready():
	var player = get_node("../main_character")
	
	player.lives_changed.connect(_on_lives_changed)
	player.coins_changed.connect(_on_coins_changed)
	
func _on_lives_changed(new_lives):
	if new_lives >= 1:
		$Lives/Life1.show()
	
	if new_lives >= 2:
		$Lives/Life2.show()
	else:
		$Lives/Life2.hide()
		
	if new_lives >= 3:
		$Lives/Life3.show()
	else:
		$Lives/Life3.hide()
	
	if new_lives >= 4:
		$Lives/Life4.show()
	else:
		$Lives/Life4.hide()

func _on_coins_changed(new_coin_count):
	$Credit/Coins.text = str(new_coin_count)
