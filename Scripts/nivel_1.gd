extends Node2D

@export var policia_scene : PackedScene
@export var camper_scene : PackedScene
@export var ciudadano_scene : PackedScene

@onready var spawn_policia: Marker2D = $Spawn_Container/spawn_policia_1
@onready var spawn_policia_2: Marker2D = $Spawn_Container/spawn_policia_2
@onready var spawn_policia_3: Marker2D = $Spawn_Container/spawn_policia_3
@onready var spawn_policia_4: Marker2D = $Spawn_Container/spawn_policia_4
@onready var spawn_policia_5: Marker2D = $Spawn_Container/spawn_policia_5
@onready var spawn_policia_6: Marker2D = $Spawn_Container/spawn_policia_6
@onready var spawn_policia_7: Marker2D = $Spawn_Container/spawn_policia_7
@onready var spawn_policia_8: Marker2D = $Spawn_Container/spawn_policia_8
@onready var spawn_policia_9: Marker2D = $Spawn_Container/spawn_policia_9
@onready var spawn_ciudadano_1: Marker2D = $Spawn_Container/spawn_ciudadano_1
@onready var spawn_ciudadano_2: Marker2D = $Spawn_Container/spawn_ciudadano_2
@onready var spawn_ciudadano_3: Marker2D = $Spawn_Container/spawn_ciudadano_3

var spawn1 := 0
var spawn2 := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crear_ciudadano(spawn_ciudadano_1)
	crear_policia_melee(spawn_policia)
	crear_camper(spawn_policia_2)
	crear_policia_shoot(spawn_policia_3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func crear_policia_melee(spawn : Marker2D):
	var policia = policia_scene.instantiate()

	policia.global_position = spawn.global_position

	policia.tipo = policia.TipoPolicia.MELEE

	add_child(policia)

func crear_policia_shoot(spawn : Marker2D):
	var policia = policia_scene.instantiate()

	policia.global_position = spawn.global_position
	
	policia.tipo = policia.TipoPolicia.PISTOLA
	
	add_child(policia)

func crear_ciudadano(spawn : Marker2D):
	var ciudadano = ciudadano_scene.instantiate()

	ciudadano.global_position = spawn.global_position

	add_child(ciudadano)

func crear_camper(spawn : Marker2D):
	var camper = camper_scene.instantiate()
	camper.global_position = spawn.global_position
	add_child(camper)

func _on_primer_spawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador") and spawn1 <= 0:
		call_deferred("crear_policia_melee", spawn_policia)
		call_deferred("crear_policia_melee" ,spawn_policia_4)
		call_deferred("crear_camper", spawn_policia_5)
		call_deferred("crear_policia_shoot", spawn_policia_6)
		call_deferred("crear_ciudadano", spawn_ciudadano_2)
		spawn1 = spawn1 + 1

func _on_primer_spawn_body_exited(body: Node2D) -> void:
	if body != null:
		body = null

func _on_segundo_spawn_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador") and spawn2 <= 0:
		call_deferred("crear_camper", spawn_policia_7)
		call_deferred("crear_camper", spawn_policia_8)
		call_deferred("crear_policia_melee", spawn_policia_9)
		call_deferred("crear_policia_melee", spawn_policia_3)
		call_deferred("crear_policia_shoot", spawn_policia)
		call_deferred("crear_ciudadano", spawn_ciudadano_3)
		spawn2 = spawn2 + 1

func _on_segundo_spawn_2_body_exited(body: Node2D) -> void:
	if body != null:
		body = null


func _on_despawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ciudadano"):
		print("Me eliminé loco")
		body.queue_free()
		
