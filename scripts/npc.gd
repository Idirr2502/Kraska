extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = $"../Player" # Wskaźnik do gracza
@onready var color_rect = $"../Player/Camera2D/dialogue_grey"
@export var npc_id: String = "npc_alice"



#func _ready() -> void:
	#interaction_area.interact = Callable(self, "_on_interact")
	#
#func _process(_delta):
	## Aktualizujemy z_index na podstawie pozycji na osi Y
	#z_index = int(global_position.y)
#
#func _on_interact():
	#color_rect.visible = true
	#DialogueManager.show_example_dialogue_balloon(load("res://dialogues/dialog1.dialogue"), "start")
	#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
#
	## Zablokowanie wejścia gracza na czas dialogu
	#disable_player_input()
#
#func _on_dialogue_ended(_status):
	## Po zakończeniu dialogu, przywracamy możliwość poruszania się
	#print("Koniec dialogu, status: ", _status)
	#color_rect.visible = false
	#enable_player_input()
#
## Funkcja do zablokowania wejścia gracza (wsad i interakcja)
#func disable_player_input():
	#player.set_process_input(false)  # Zablokowanie wejść
#
## Funkcja do przywrócenia wejścia gracza
#func enable_player_input():
	#player.set_process_input(true)  # Przywrócenie wejść


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var dialogue_controller = %DialogueController
		dialogue_controller.current_npc_id = npc_id
		%GameManager.in_dialogue_area = true



func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var dialogue_controller = %DialogueController
		if dialogue_controller.current_npc_id == npc_id:
			dialogue_controller.current_npc_id = ""
		%GameManager.in_dialogue_area = false
