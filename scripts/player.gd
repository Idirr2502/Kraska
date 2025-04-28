extends CharacterBody2D

@export var move_speed := 300.0
@export var roll_duration := 0.25

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_direction := Vector2.DOWN  # Domyślny kierunek w dół

# lamp impl
var lamp_visible : bool = true

func _process(_delta):
	z_index = int(global_position.y)
	
	#lamp impl
	if Input.is_action_just_pressed("lamp"):
		lamp_visible = !lamp_visible
		
	%lamp.visible = lamp_visible

func _physics_process(_delta):
	if globals.can_move:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

		if input_vector.length() > 1:
			input_vector = input_vector.normalized()

		velocity = input_vector * move_speed

		if input_vector != Vector2.ZERO:
			last_direction = input_vector
			play_walk_animation(input_vector)
		else:
			play_idle_animation(last_direction)

		move_and_slide()

func play_walk_animation(direction: Vector2):
	var anim_name := ""

	if abs(direction.x) < abs(direction.y):
		anim_name = "walk_down" if direction.y > 0 else "walk_up"
	else:
		anim_name = "walk_right" if direction.x > 0 else "walk_left"

	if anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)

func play_idle_animation(direction: Vector2):
	var anim_name := ""

	if abs(direction.x) > abs(direction.y):
		anim_name = "idle_right" if direction.x > 0 else "idle_left"
	else:
		anim_name = "idle_down" if direction.y > 0 else "idle_up"

	if anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)
