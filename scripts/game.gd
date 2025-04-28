extends Node2D

@onready var color_rect = $Player/Camera2D/dialogue_grey
@onready var player = $Player

func _ready() -> void:
	# Rozpoczynamy dialog
	color_rect.visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/tutorial.dialogue"), "start")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	# Zablokowanie wejścia gracza na czas dialogu
	disable_player_input()

func _on_dialogue_ended(_status):
	# Po zakończeniu dialogu, przywracamy możliwość poruszania się
	print("Koniec dialogu, status: ", _status)
	color_rect.visible = false
	enable_player_input()

# Funkcja do zablokowania wejścia gracza (wsad i interakcja)
func disable_player_input():
	player.set_process_input(false)  # Zablokowanie wejść

# Funkcja do przywrócenia wejścia gracza
func enable_player_input():
	player.set_process_input(true)  # Przywrócenie wejść


func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
