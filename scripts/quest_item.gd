extends Control

@export var title: String
@export var description: String
@export var checkboxes: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in checkboxes:
		var quest_checkbox = Label.new()
		quest_checkbox.text = c
		var entry = HBoxContainer.new()
		var checkbox = CheckBox.new()
		checkbox.disabled = true
		entry.add_child(checkbox)
		entry.add_child(quest_checkbox)
		$VBoxContainer.add_child(entry)
	# tu można dać jakieś tam auto generowanie minimalnej wysokości questa kiedyś jak zajdzie potrzeba
	custom_minimum_size.y = 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
