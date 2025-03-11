extends CharacterBody2D

@export var move_speed := 100.0
@export var roll_speed := 250.0
@export var roll_duration := 0.25

var is_rolling := false
var roll_timer := 0.0
var roll_direction := Vector2.ZERO

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_played_anim := ""

func _process(_delta):
	z_index = int(global_position.y)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Normalizacja wektora dla równej prędkości po skosie
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	# Roll
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false

		# Ustalamy stałą prędkość podczas rolla
		velocity = roll_direction * roll_speed

		# Jeśli animacja rolla jeszcze się nie rozpoczęła, to ją zaczynamy
		if last_played_anim != "roll":
			start_roll(roll_direction)
	else:
		if Input.is_action_just_pressed("roll") and input_vector != Vector2.ZERO:
			start_roll(input_vector)
		else:
			velocity = input_vector * move_speed

			if input_vector != Vector2.ZERO:
				play_animation("run", input_vector)
			else:
				play_animation("idle", Vector2.ZERO)

	move_and_slide()

func start_roll(direction: Vector2):
	# Startujemy rolla
	is_rolling = true
	roll_timer = roll_duration
	roll_direction = direction
	velocity = roll_direction * roll_speed

	# Jeśli animacja nie jest już odtwarzana, uruchom ją
	if anim_sprite.animation != "roll":
		anim_sprite.play("roll", true)  # Drugi argument "true" wymusza restart płynnie
		last_played_anim = "roll"

func play_animation(state: String, direction: Vector2, force_restart := false):
	# Jeżeli animacja nie jest ta sama lub wymuszamy restart
	if anim_sprite.animation != state or force_restart:
		anim_sprite.play(state)
		last_played_anim = state

	# Obracanie sprite'a w lewo/prawo
	if direction.x != 0:
		anim_sprite.flip_h = direction.x < 0
