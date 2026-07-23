extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0

enum ItemType {
	TELEVISOR,
	CELULAR,
	PARLANTE,
	COBRE,
	ELECTRODIMESTICO
	
}

var target
var precio : int
var item
var check_robo : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	item = ItemType.values().pick_random()
	actualizar_precio()


func actualizar_precio():
	if item == ItemType.TELEVISOR:
		precio = 300
	if item == ItemType.CELULAR:
		precio = 100
	if item == ItemType.PARLANTE:
		precio = 150
	if item == ItemType.COBRE:
		precio = 50
	if item == ItemType.ELECTRODIMESTICO:
		precio = 200


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if target != null and GameManager.is_interaccion == true:
		if check_robo == 0:
			target.sumar_dinero(precio)
			GameManager.ciudadano_roba2 = true
			check_robo = 1
		


	velocity = Vector2.LEFT * SPEED
	animated_sprite.play("Move")
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		target = body
		print("MI TARGET ES: ",target)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != null:
		target = null
