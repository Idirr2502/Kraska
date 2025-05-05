extends Control

#possibly save globally or export
var InvSize = 16
var itemsLoad = [
	"res://items(resources)/potion.tres",
	"res://items(resources)/cherry.tres"
]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = !self.visible
	
func _ready():
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32,32))
		%Inv.add_child(slot)
	
	for i in itemsLoad.size():
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		%Inv.get_child(i).add_child(item)


# when making the real game, change the scene to the game scene here
func _on_back_button_pressed() -> void:
	get_tree().paused = false
	visible = false
