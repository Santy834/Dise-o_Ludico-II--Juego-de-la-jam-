extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D


enum TipoPolicia {
	MELEE,
	PISTOLA
}

@export var tipo : TipoPolicia
@export var bullet_scene : PackedScene
@export var speed := 120.0
@export var attack_distance := 400.0
@export var vida : int = 1 

var player : CharacterBody2D
var attacking : = false
var has_shot : = false
var target

func _ready():
	player = get_tree().get_first_node_in_group("Jugador")

func _physics_process(delta):
	if player == null:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	match tipo:
		TipoPolicia.MELEE:
			melee_behavior()

		TipoPolicia.PISTOLA:
			pistol_behavior()

	if target != null:
		target.recibir_daño(1)

	if attacking:
		check_attack_frame()
		
	move_and_slide()

func check_attack_frame():
	# Disparar en el frame x
	if animated_sprite.frame == 4 and not has_shot:
		has_shot = true
		disparar()

	# Cuando termina la animación
	var last_frame = animated_sprite.sprite_frames.get_frame_count("Arrojar") - 1

	if animated_sprite.frame >= last_frame:
		attacking = false

func melee_behavior():

	var direction = sign(
		player.global_position.x - global_position.x
	)

	velocity.x = direction * speed

	animated_sprite.flip_h = direction < 0

	if abs(velocity.x) > 0:
		animated_sprite.play("Movimiento")

func pistol_behavior():

	var distance = abs(player.global_position.x - global_position.x)
	var direction = sign(player.global_position.x - global_position.x)

	animated_sprite.flip_h = direction < 0

	if attacking:
		velocity.x = 0
		return

	if distance > attack_distance:

		velocity.x = direction * speed

		if animated_sprite.animation != "Movimiento":
			animated_sprite.play("Movimiento")

	else:

		velocity.x = 0
		attacking = true
		has_shot = false
		animated_sprite.play("Arrojar")

func disparar():
	var bullet = bullet_scene.instantiate()

	var spawn_offset = Vector2(100, 50)

	if animated_sprite.flip_h:
		spawn_offset.x *= -1

	bullet.global_position = global_position + spawn_offset

	bullet.direction = (
		player.global_position - bullet.global_position
	).normalized()

	get_parent().add_child(bullet)

func recibir_daño(golpe : int):
	if vida > 0:
		vida = vida - golpe
		print("La vida del policia es: ",vida)
		GameManager.policia_muere = true
	else:
		queue_free()
	

func _on_area_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		target = body

func _on_area_ataque_body_exited(body: Node2D) -> void:
	if target == body:
		target = null
