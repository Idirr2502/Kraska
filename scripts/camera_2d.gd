extends Camera2D

@export var SMOOTHING_ENABLED = true  # Możliwość włączenia wygładzania
@export var SMOOTHING_SPEED = 0.3  # Prędkość wygładzania (0.0 - 1.0)
@export var CAMERA_OFFSET_Y = 20  # Przesunięcie kamery o 20 pikseli w górę
@export var MIN_X = -500  # Minimalna wartość X (lewa granica)
@export var MAX_X = 500   # Maksymalna wartość X (prawa granica)
@export var MIN_Y = -300  # Minimalna wartość Y (górna granica)
@export var MAX_Y = 300   # Maksymalna wartość Y (dolna granica)

@onready var player: CharacterBody2D = $"../Player"

func _process(_delta):
	# Pozycja celu to pozycja gracza
	var target_position = player.position
	target_position.y -= CAMERA_OFFSET_Y  # Uwzględniamy przesunięcie Y

	# Interpolacja (wygładzanie) - jeśli włączona
	if SMOOTHING_ENABLED:
		position = position.lerp(target_position, SMOOTHING_SPEED)
	else:
		position = target_position  # Bez wygładzania

	# Ograniczanie pozycji kamery
	position.x = clamp(position.x, MIN_X, MAX_X)  # Ograniczenie X
	position.y = clamp(position.y, MIN_Y, MAX_Y)  # Ograniczenie Y
