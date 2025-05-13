extends Control
#guzik co będzie się renderować
@export var choice_button_scene: PackedScene
#a tu są takie zmienne wyeksportowane aby łatwiej tymi dialogami zarządzać
@export var dialogue_font: Font
@export var speaker_font: Font
@export var dialogue_font_size: int = 18
@export var speaker_font_size: int = 22

@onready var player = %Player

var dialogue_map: Dictionary = {}
var current_sequence: DialogueSequence
var current_index: int = 0
#odpali ten dialog, który jest w tym id niżej. W pliku json masz current_dialogue_id jako klucz do array'a dialogów.
#na jakimś area2D musisz obsłużyć logikę przekazania id_dialogu który zamierzasz odpalić
#przykład w skrypcie npc.
var current_dialogue_id: String = ""
var is_in_dialogue: bool = false
#jak jesteśmy w trakcie wyboru to nie możemy przewinąć tej opcji dialogowej
var awaiting_choice := false

#a tu do testowania daję zmienną żeby zobaczyć jak działają wybory, ale można ją dać do global vars
var player_choice

#tu mapujemy czy dane dialogi już się odbyły. Przydatne jesli nie chcemy powtarzać tego
#samego dialogu wiele razy
#var npc_dialog_state: Dictionary = {}

func load_all_dialogues_from_json(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Could not open dialogue file")
		return

	var json_text = file.get_as_text()
	var parsed = JSON.parse_string(json_text)
	if parsed == null:
		push_error("Invalid JSON")
		return

	for key in parsed.keys():
		var sequence = DialogueSequence.new()
		sequence.load_from_array(parsed[key])
		dialogue_map[key] = sequence

	print("Loaded dialogues for: ", dialogue_map.keys())

func start_dialogue(dialogue_id: String):
	if dialogue_map.has(dialogue_id):
		
		#tu jest implementacja tej opcjonalnej logiki do dialogów które się już odbyły, ale narazie
		#jest niedopracowana więc zostawiam.
		
		#if npc_dialog_state.has(dialogue_id) and npc_dialog_state[dialogue_id]:
			#print("Dialog with this NPC already happened.")
			#get_tree().paused = false
			#return
		#else:
			player.set_process_input(false)
			var sequence: DialogueSequence = dialogue_map[dialogue_id]
			play_dialogue(sequence)
			is_in_dialogue = true
			visible = true
			%UI.visible = false
			#tu ustawiamy że dialog z danym npc już się odbył
			#npc_dialog_state[dialogue_id] = true
	else:
		print("No dialogue found for ", dialogue_id)
		
func play_dialogue(sequence: DialogueSequence) -> void:
	current_sequence = sequence
	current_index = 0
	show_current_line()

func show_current_line() -> void:
	if current_sequence == null or current_index >= current_sequence.lines.size():
		print("Dialogue ended.")
		visible = false
		is_in_dialogue = false
		get_tree().paused = false
		%Speaker.text = ""
		%DialogueContent.text = ""
		%Portrait.texture = null
		%UI.visible = true
		player.set_process_input(true)
		return

	var line = current_sequence.lines[current_index]
	%Speaker.text = line.speaker_name
	%DialogueContent.text = line.dialogue_text
	# tu trzeba bedzie dodac ladowanie tekstury osoby ktora sie wypowiada
	# można zobaczyć w dialogues/dialoguesJSON/test.json jakieś przykładowe ścieżki
	# a same tekstury trzymam w dialogues/compressed_character_textures
	# narazie skopiowałem te co są dostępne
	%Portrait.texture = line.portrait_texture
	
	# a tu mamy dodawanie wyborów
	if line.choices.size() > 0:
		show_choices(line.choices)
		awaiting_choice = true
	else:
		%ChoicePanel.visible = false
		awaiting_choice = false

func next_line() -> void:
	current_index += 1
	show_current_line()

func _unhandled_input(event):
	if event.is_action_pressed("ui_interact"):
		if is_in_dialogue:
			if not awaiting_choice:
				next_line()
		elif current_dialogue_id != "":
			start_dialogue(current_dialogue_id)


func _ready():
	# json path to dialogues
	var dialogue_json_path = "res://dialogues/dialoguesJSON/test.json" 
	load_all_dialogues_from_json(dialogue_json_path)
	print("Dialogue controller initialized and dialogues loaded.")
	apply_fonts()
	
func show_choices(choices: Array):
	%ChoicePanel.visible = true
	for child in %ChoicePanel.get_children():
		child.queue_free()

	for choice_text in choices:
		var button = choice_button_scene.instantiate()
		button.text = choice_text
		button.pressed.connect(_on_choice_selected.bind(choice_text))
		%ChoicePanel.add_child(button)

func _on_choice_selected(choice_text: String):
	# jeśli nasze wybory mają mieć jakiś wpływ na otoczenie, to tutaj zapamiętujemy aktualnie wybraną
	# guzikiem zmienną
	print("Player chose:", choice_text)
	%ChoicePanel.visible = false
	awaiting_choice = false
	next_line()
	
	#tu jest taka hard_coded logika jak można korzystać z wyborów, po prostu
	#odpalam dialog na podstawie wyboru w tej scenie, możesz zobaczyć JSON'a
	#w nim są zdefiniowane klucze do poszczególnych wyborów
	#np babcia_dialog_1_placki
	start_dialogue("babcia_dialog_1_" + choice_text.to_lower())
	
	#i zmieniamy kolejny dialog babci na babcia_koniec
	

func apply_fonts():
	if speaker_font:
		var speaker_theme = Theme.new()
		speaker_theme.set_font("font", "Label", speaker_font)
		speaker_theme.set_font_size("font_size", "Label", speaker_font_size)
		%Speaker.theme = speaker_theme

	if dialogue_font:
		var dialogue_theme = Theme.new()
		dialogue_theme.set_font("font", "Label", dialogue_font)
		dialogue_theme.set_font_size("font_size", "Label", dialogue_font_size)
		%DialogueContent.theme = dialogue_theme
	
