extends Node2D

func _process(_delta):
	# Aktualizujemy z_index na podstawie pozycji na osi Y
	z_index = int(global_position.y)
