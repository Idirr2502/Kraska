extends Node2D
@export var lamp_time_increment: int = 5

func _on_oil_pickup_area_body_entered(body: Node2D) -> void:
	print("Player took oil!")
	if %GameManager.current_lamp_time + lamp_time_increment <= %GameManager.lamp_time: 
		%GameManager.current_lamp_time += lamp_time_increment
	else:
		%GameManager.current_lamp_time = %GameManager.lamp_time
	queue_free()
