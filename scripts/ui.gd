extends Control

func _on_sack_button_pressed() -> void:
	get_tree().paused = true
	%Sack.visible = true


func _on_modlitewnik_button_pressed() -> void:
	get_tree().paused = true
	%Modlitewnik.visible = true

func _process(delta: float) -> void:
	if Input.is_action_pressed("inventory"):
		get_tree().paused = true
		%Sack.visible = true
	if Input.is_action_pressed("vestnik"):
		get_tree().paused = true
		%Modlitewnik.visible = true
