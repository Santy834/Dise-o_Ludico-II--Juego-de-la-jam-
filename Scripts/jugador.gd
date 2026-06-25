extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dinero_lb: Label = $CanvasLayer/Control/MarginContainer/Dinero/VBoxContainer/Dinero_Lb
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var cooldown_vida: Timer = $Cooldown_vida

# Variables de movimiento
@export var SPEED = 300.0
@export var dash_Speed := 800.0
@export var dash_duration := 0.2
@export var dash_cooldown := 0.4
@export var JUMP_VELOCITY = -600.0
@export var bullet_scene : PackedScene

var is_dashing : bool = false
var can_dash : bool = true
var air_dash_available := true
var dash_direction := 1.0
var dash_timer : float = 0.0

var estado_actual
var estado_anterior = -1
var inmunidad : bool = false
var has_shot : bool = false
var attacking : bool = false


var hizo_doble_salto : bool = false

enum estados {
	IDLE,
	MOVE,
	JUMP,
	DOBLE_JUMP,
	SHOOT,
	DASH
}
#	Esta variable de configuración afecta a la posición 
#	en el eje Y de la camara del jugador
		#@export var offset_camera : float


# Variables del salto
var salto_acumulado : int

var dinero : int

func _ready() -> void:
	estado_actual = estados.IDLE

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Click_izq"):
		attacking = true
	
	if attacking == true:
		check_attack_frame()

	if Input.is_action_just_pressed("Interaccion"):
		GameManager.is_interaccion = true
	else:
		GameManager.is_interaccion = false

	if GameManager.vida_pj > 0:
		_salto(delta)
		movimiento(delta)
		actualizar_estado()
		animation_update()
		actualizar_HUD()
	else:
		game_over()

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
		
		if direction != 0 :
			dash_direction = sign(direction)
			velocity.x = direction * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		
		if Input.is_action_just_pressed("dash") and GameManager.dash_desbloqueado == true:
			start_dash()

	move_and_slide()

func recibir_daño(daño : int):
	if inmunidad != false:
		return
		
	GameManager.vida_pj = GameManager.vida_pj - daño
	inmunidad = true
	cooldown_vida.start()

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
		hizo_doble_salto = false

	# Handle jump.
	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		salto_acumulado += 1
		
	
	if GameManager.doble_salto_desbloqueado == true:
		if Input.is_action_just_pressed("Salto") and not is_on_floor():
			if salto_acumulado < 2:
				velocity.y = JUMP_VELOCITY
				salto_acumulado += 1
				hizo_doble_salto = true
		#pass

func check_attack_frame():
	# Disparar en el frame x
	if animated_sprite.frame == 3 and not has_shot:
		has_shot = true
		disparar()
		print("Dispare")
		

func disparar():
	var mouse_pos = get_global_mouse_position()

	if not animated_sprite.flip_h:
		# Mira a la derecha
		if mouse_pos.x < global_position.x:
			return
	elif animated_sprite.flip_h:
		# Mira a la izquierda
		if mouse_pos.x > global_position.x:
			return
		

	var bullet = bullet_scene.instantiate()
	
	var spawn_offset = Vector2(50, 50)
	
	if animated_sprite.flip_h:
		spawn_offset.x *= -1

	bullet.global_position = global_position + spawn_offset

	bullet.direction = (
		mouse_pos - bullet.global_position
	).normalized()

	get_parent().add_child(bullet)

func sumar_dinero(money : int):
	dinero = dinero + money
	print("Mi dinero es: ", dinero)

func game_over():
	if GameManager.vida_pj <= 0:
		get_tree().change_scene_to_file("res://Escenas/gameover.tscn")

func actualizar_HUD():
	dinero_lb.text = str(dinero)
	canvas_layer.update_hearts(GameManager.vida_pj)

func actualizar_estado():
	if is_dashing:
		estado_actual = estados.DASH
		return

	if not is_on_floor():
		if hizo_doble_salto:
			estado_actual = estados.DOBLE_JUMP
		else:
			estado_actual = estados.JUMP
		return

	if abs(velocity.x) > 10:
		estado_actual = estados.MOVE
	else:
		estado_actual = estados.IDLE
	
	if attacking:
		estado_actual = estados.SHOOT
		return

func animation_update():
	if velocity.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	if estado_actual != estado_anterior:
			
		match estado_actual:

			estados.IDLE:
				animated_sprite.play("Idle")
				
			estados.MOVE:
				animated_sprite.play("Move")
				
			estados.JUMP:
				animated_sprite.play("Salto")
				
			estados.DOBLE_JUMP:
				animated_sprite.play("Doble_JUMP")
			
			estados.SHOOT:
				animated_sprite.play("Arrojar")
			
			estados.DASH:
				animated_sprite.play("DASH")
		
		estado_anterior = estado_actual


func _on_cooldown_vida_timeout() -> void:
	inmunidad = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Arrojar":
		print("Fin de la animación")
		has_shot = false
		attacking = false
	
		
