extends Area2D

# Zmienna, która będzie trzymała dostęp do skryptu globalnego
var globals_script : Node

func _on_body_entered(_body: Node2D) -> void:
		# Sprawdzamy, czy zmienna can_exit w globals_script jest prawdziwa
	print (globals.can_exit)
	if globals.can_exit:
		# Zmieniamy scenę
		get_tree().quit()
