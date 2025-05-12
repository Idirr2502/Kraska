extends Control
var dialogue_map: Dictionary = {}
var current_sequence: DialogueSequence
var current_index: int = 0
var current_npc_id: String = ""
var is_in_dialogue: bool = false

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

func start_dialogue(npc_id: String):
	if dialogue_map.has(npc_id):
		var sequence: DialogueSequence = dialogue_map[npc_id]
		play_dialogue(sequence)
		is_in_dialogue = true
		visible = true
		%UI.visible = false
	else:
		print("No dialogue found for ", npc_id)
		
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
		# %Portrait.texture = null
		%UI.visible = true
		return

	var line = current_sequence.lines[current_index]
	%Speaker.text = line.speaker_name
	%DialogueContent.text = line.dialogue_text
	# tu trzeba bedzie dodac ladowanie tekstury osoby ktora sie wypowiada
	#%Portrait.texture = line.portrait_texture

func next_line() -> void:
	current_index += 1
	show_current_line()

func _unhandled_input(event):
	if event.is_action_pressed("ui_interact"):
		if is_in_dialogue:
			next_line()
		elif current_npc_id != "":
			start_dialogue(current_npc_id)


func _ready():
	# Specify the path to your JSON file
	var dialogue_json_path = "res://dialogues/dialoguesJSON/test.json"  # Adjust the path as needed
	load_all_dialogues_from_json(dialogue_json_path)
	# Optionally, you can log the loaded data or trigger further actions
	print("Dialogue controller initialized and dialogues loaded.")
