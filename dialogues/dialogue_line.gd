extends Resource
class_name DialogueLineData

var speaker_name: String
var dialogue_text: String
var portrait_texture: Texture2D
var choices: Array = []

func load_from_dict(data: Dictionary):
	speaker_name = data.get("speaker_name", "")
	dialogue_text = data.get("dialogue_text", "")
	var path = data.get("portrait_path", "")
	if path != "":
		portrait_texture = load(path)
	choices = data.get("choices",[])
