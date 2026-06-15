extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -800.0

#	Esta variable de configuración afecta a la posición 
#	en el eje Y de la camara del jugador
		#@export var offset_camera : float

# Variables del salto
@export var doble_salto_desbloqueado : bool
var salto_acumulado : int

func _ready() -> void:
	# Para afectar la posición de la camara quitar el "#"
		#camera.global_position.y = camera.global_position.y + offset_camera
	doble_salto_desbloqueado = false
	

func _physics_process(delta: float) -> void:
	_salto(delta)
	movimiento()

func movimiento():
	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _salto(delta : float):
	print("Tu saltos acumulados son: ", salto_acumulado)
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		salto_acumulado = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		salto_acumulado += 1
	
	if doble_salto_desbloqueado == true:
		if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
			if salto_acumulado < 2:
				velocity.y = JUMP_VELOCITY
				salto_acumulado += 1
