extends Area2D

@export var data_script: Script
var data_instance

func _ready():
	if data_script:
		data_instance = data_script.new()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.collect_data(data_instance)
		queue_free()
