extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _process(_delta):
	# Aktualizujemy z_index na podstawie pozycji na osi Y
	z_index = int(global_position.y)

func _on_interact():
	print("Interakcja ze ścianą")
