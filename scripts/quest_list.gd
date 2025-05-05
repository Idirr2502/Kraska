extends VBoxContainer
@export var quests: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for q in quests:
		var qi = q.instantiate()
		%QuestList.add_child(qi)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
