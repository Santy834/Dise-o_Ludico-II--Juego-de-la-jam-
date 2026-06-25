extends Node2D

@export var policia_scene : PackedScene
@export var ciudadano_scene : PackedScene

@onready var spawn_policia: Marker2D = $Spawn_Container/spawn_policia_1
@onready var spawn_policia_2: Marker2D = $Spawn_Container/spawn_policia_2
@onready var spawn_policia_3: Marker2D = $Spawn_Container/spawn_policia_3
@onready var spawn_ciudadano_1: Marker2D = $Spawn_Container/spawn_ciudadano_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crear_ciudadano(spawn_ciudadano_1)
	crear_policia_melee(spawn_policia)
	crear_policia_melee(spawn_policia_2)
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
