extends Node2D

@onready var objetivo_lb: Label = $CanvasLayer/Panel/objetivo_LB
@onready var spawn_policia = $SpawnPolicia
@onready var finalizar_btn: Button = $CanvasLayer/Panel/finalizar_btn

@export var policia_scene: PackedScene
@export var ciudadano_scene: PackedScene

enum TutorialStep {
	MOVERSE,
	SALTAR,
	DISPARAR,
	RECOGER,
	FINALIZADO
}

var current_step = TutorialStep.MOVERSE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mostrar_mensaje()
	finalizar_btn.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.policia_muere:
		paso_disparo()
	
	if GameManager.ciudadano_roba2:
		paso_recoger()

func _input(event):

	if Input.is_action_just_pressed("A") \
	or Input.is_action_just_pressed("D"):

		paso_movimiento()

	if Input.is_action_just_pressed("Salto"):
		paso_salto()


func paso_movimiento():

	if current_step == TutorialStep.MOVERSE:
		current_step = TutorialStep.SALTAR
		mostrar_mensaje()


func paso_salto():

	if current_step == TutorialStep.SALTAR:
		current_step = TutorialStep.DISPARAR
		mostrar_mensaje()
		crear_policia()


func paso_disparo():

	if current_step == TutorialStep.DISPARAR:
		current_step = TutorialStep.RECOGER
		crear_ciudadano()
		mostrar_mensaje()

func paso_recoger():
	if current_step == TutorialStep.RECOGER and GameManager.ciudadano_roba2:
		current_step = TutorialStep.FINALIZADO
		mostrar_mensaje()
		finalizar_btn.visible = true

func mostrar_mensaje():
	match current_step:
		TutorialStep.MOVERSE:
			objetivo_lb.text = "USA 'A' y 'D' PARA MOVERTE"

		TutorialStep.SALTAR:
			objetivo_lb.text = "PRESIONA 'ESPACIO' PARA SALTAR"

		TutorialStep.DISPARAR:
			objetivo_lb.text = "APARECIO UN POLI 'CLICK IZQUIERDO' PARA ARROJARLE ALGO"

		TutorialStep.RECOGER:
			objetivo_lb.text = "PRECIONA 'E' SOBRE UN CIUDADANOS PARA OBTENER DINERO"

		TutorialStep.FINALIZADO:
			objetivo_lb.text = "TUTORIAL FINALIZADO"
			

func crear_policia():
	var policia = policia_scene.instantiate()

	policia.global_position = spawn_policia.global_position

	add_child(policia)

func crear_ciudadano():
	var ciudadano = ciudadano_scene.instantiate()

	ciudadano.global_position = spawn_policia.global_position

	add_child(ciudadano)


func _on_finalizar_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/MAPAS/nivel_1.tscn")
