extends Resource
class_name DialogueLineData

@export var speaker_name: String
@export var dialogue_text: String
@export var portrait_texture: Texture2D

func load_from_dict(data: Dictionary):
	speaker_name = data.get("speaker_name", "")
	dialogue_text = data.get("dialogue_text", "")
	var path = data.get("portrait_path", "")
	if path != "":
		portrait_texture = load(path)
