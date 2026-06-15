extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D

# Variables de movimiento
@export var SPEED = 300.0
@export var dash_Speed := 800.0
@export var dash_duration := 0.2
@export var dash_cooldown := 0.4
@export var JUMP_VELOCITY = -800.0

var is_dashing : bool = false
var can_dash : bool = true
var air_dash_available := true
var dash_direction := 1.0
var dash_timer : float = 0.0

#	Esta variable de configuración afecta a la posición 
#	en el eje Y de la camara del jugador
		#@export var offset_camera : float


# Variables del salto
var salto_acumulado : int

var dinero : int

func _ready() -> void:
	# Para afectar la posición de la camara quitar el "#"
		#camera.global_position.y = camera.global_position.y + offset_camera
	#GameManager.doble_salto_desbloqueado = false
	pass

func _physics_process(delta: float) -> void:
	_salto(delta)
	movimiento(delta)

func movimiento(delta : float):
	
	# Dash
	if is_dashing:
		velocity.x = dash_direction * dash_Speed
		velocity.y = 0
		dash_timer -= delta
		
		if dash_timer <= 0:
			is_dashing = false
	
	else: 
		#Movimiento horizontal
		var direction := Input.get_axis("A", "D")
		
		if direction != 0:
			dash_direction = sign(direction)
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("dash") and GameManager.dash_desbloqueado == true:
			start_dash()

	move_and_slide()

func start_dash():
	if not can_dash:
		return
	
	if not is_on_floor():
		if not air_dash_available:
			return
		air_dash_available = false
		
	can_dash = false
	is_dashing = true
	dash_timer = dash_duration
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _salto(delta : float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		salto_acumulado = 0
		air_dash_available = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		salto_acumulado += 1
	
	if GameManager.doble_salto_desbloqueado == true:
		if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
			if salto_acumulado < 2:
				velocity.y = JUMP_VELOCITY
				salto_acumulado += 1

func sumar_dinero(money : int):
	dinero = dinero + money
	
func game_over():
	if GameManager.vida_pj <= 0:
		pass
