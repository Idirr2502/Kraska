extends Control

#possibly save globally or export
var InvSize = 16
var itemsLoad = [
	"res://items(resources)/Destiny.tres",
	"res://items(resources)/Truth.tres"
]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("vestnik"):
		get_tree().paused = false
		%Modlitewnik.visible = false
	
func _ready():
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(64,64))
		%Inv.add_child(slot)
	
	for i in itemsLoad.size():
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		%Inv.get_child(i).add_child(item)


func _on_back_button_pressed() -> void:
	get_tree().paused = false
	visible = false
