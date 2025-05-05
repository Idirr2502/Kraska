extends Node

# UV power impl

# values above 1 make the cooldown shorter than load, values below one the opposite
@export var load_to_cooldown_ratio := 0.6
@export var uv_duration := 3.0
@export_range(0.1, 5.0, 0.1) var fade_ratio: float = 2
var current_duration := 0.0
var uv_cooldown = false
var uv_active = false
@export var secret_stuff: Array[Node]

#lamp impl
@export var lamp_time : float = 10.0

func _ready() -> void:
	%DurationLabel.text = "supehrmoc UV naładowanie: 100%"
	globals.can_move = true

func _process(delta: float) -> void:
	
	# UV power impl
	if !uv_cooldown && Input.is_action_pressed("uv") && current_duration <= uv_duration:
		uv_active = true
		current_duration += delta
		var uv_percent = round((1.0 - (current_duration / uv_duration))*100)
		%DurationLabel.text = "supehrmoc UV naładowanie: %.0f" % uv_percent + "%"
	elif current_duration > 0:
		uv_active = false
		uv_cooldown = true
		current_duration -= delta * load_to_cooldown_ratio
		var uv_percent = round((1.0 - (current_duration / uv_duration))*100)
		%DurationLabel.text = "supehrmoc UV naładowanie: %.0f" % uv_percent + "%"
	else:
		uv_active = false
		uv_cooldown = false
	#check if uv is active or not and fade the nodes accordingly
	for node in secret_stuff:
		if node and node is CanvasItem:
			var color = node.modulate
			if uv_active:
				color.a = min(color.a + delta * fade_ratio, 1.0) # fade in faster
			else:
				color.a = max(color.a - delta * fade_ratio, 0.0) # fade out faster
			node.modulate = color
	
	#lamp processing
	
	if %Player.get_child(0).lamp_visible && lamp_time > 0.0:
		lamp_time -= delta
		lamp_time = clamp(lamp_time, 0.0, 10.0)
		%LampDuration.text = "lampoczas: %.2f" % lamp_time
	if lamp_time <= 0:
		%Player.get_child(0).lamp_visible = false
