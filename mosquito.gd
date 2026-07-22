extends CharacterBody2D


@export var velocidad := 120.0
@export var distancia_idle := 500.0
@export var velocidad_ataque := 400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Estado {
	Idle,
	Acercarse,
	Ataque,
	Posicionarse
}

var estado_actual : Estado = Estado.Acercarse
var jugador : CharacterBody2D 
var tiempo_idle := 0.0
var objetivo_ataque : Vector2
var punto_retorno: Vector2
var offset_objetivo = Vector2(0, -100)

func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("Jugador")

func _physics_process(delta):

	match estado_actual:

		Estado.Acercarse:
			actualizar_acercarse()
			animated_sprite.play("Idel")

		Estado.Idle:
			actualizar_idle(delta)
			animated_sprite.stop()

		Estado.Ataque:
			actualizar_ataque()
			animated_sprite.stop()

		Estado.Posicionarse:
			actualizar_posicionarse()
			animated_sprite.stop()

	move_and_slide()

func cambiar_estado(nuevo_estado: Estado):
	estado_actual = nuevo_estado
	match estado_actual:
		
		Estado.Acercarse:
			entrar_acercarse()
		
		Estado.Idle:
			entrar_idle()
		
		Estado.Ataque:
			entrar_ataque()
		
		Estado.Posicionarse:
			entrar_posicionarse()

func entrar_acercarse():
	print("estoy acercandome")

func actualizar_acercarse():
	var direccion = (jugador.global_position - global_position).normalized()
	velocity = direccion * velocidad
	
	var distancia = (global_position.distance_to(jugador.global_position))
	if distancia <= distancia_idle:
		cambiar_estado(Estado.Idle)

func entrar_idle():
	tiempo_idle = 0.0
	velocity = Vector2.ZERO
	print("prepararé mi ataque")
	

func actualizar_idle(delta: float):
	tiempo_idle += delta
	
	#Codigo del movimiento en U
	if tiempo_idle >= 3:
		cambiar_estado(Estado.Ataque)

func entrar_ataque():
	objetivo_ataque = jugador.global_position + offset_objetivo
	punto_retorno = global_position
	print("Voy hacia a tí")

func actualizar_ataque():
	var direccion = (objetivo_ataque - global_position).normalized()
	velocity = direccion * velocidad_ataque
	
	#var distancia = global_position.distance_to(objetivo_ataque)

	if global_position.distance_to(objetivo_ataque) < 20:
		print("es hora de volver")
		cambiar_estado(Estado.Posicionarse)

func entrar_posicionarse():
	print("volveré a mi posición")

func actualizar_posicionarse():
	var direccion = (punto_retorno - global_position).normalized()
	velocity += direccion * velocidad 
	
	var distancia = (global_position.distance_to(jugador.global_position))
	
	if global_position.distance_to(punto_retorno) < 50:
		if distancia <= distancia_idle:
			cambiar_estado(Estado.Idle)
		else:
			cambiar_estado(Estado.Acercarse)
