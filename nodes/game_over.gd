extends CanvasLayer

@export var next_scene: PackedScene
var transition = false

func _ready():
	$AnimationPlayer.play("game_over")
	await $AnimationPlayer.animation_finished
	transition = true
	
func _process(delta):
	if transition:
		if Input.is_action_just_pressed("shoot"):
			if next_scene:
				get_tree().change_scene_to_packed(next_scene)
