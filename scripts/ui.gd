extends Control

func _on_sack_button_pressed() -> void:
	get_tree().paused = true
	%Sack.visible = true


func _on_modlitewnik_button_pressed() -> void:
	get_tree().paused = true
	%Modlitewnik.visible = true
