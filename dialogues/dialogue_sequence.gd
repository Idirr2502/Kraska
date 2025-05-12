extends Resource
class_name DialogueSequence

@export var lines: Array[DialogueLineData] = []

func load_from_array(arr: Array):
	for item in arr:
		var line = DialogueLineData.new()
		line.load_from_dict(item)
		lines.append(line)
