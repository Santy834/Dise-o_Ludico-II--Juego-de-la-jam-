extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var bullet_scene : PackedScene
@export var attack_distance := 400
@export var vida := 1

var player : CharacterBody2D
var attack := false
var has_shot := false

func _ready():
	player = get_tree().get_first_node_in_group("Jugador")

func _process(delta: float) -> void:
	distancia_para_atacar()
	
	if attack:
		check_ataque()

func distancia_para_atacar():
	var distance = abs(player.global_position.x - global_position.x)
	var direction = sign(player.global_position.x - global_position.x)

	animated_sprite.flip_h = direction < 0

	if attack:
		velocity.x = 0
		return
	
	if distance <= attack_distance:
		velocity.x = 0
		attack = true
		has_shot = false
		animated_sprite.play("default")

func dispara_bullet():
	var bullet = bullet_scene.instantiate()
	var spawn_point = Vector2(100, 50)
	
	if animated_sprite.flip_h:
		spawn_point.x *= -1
	
	bullet.global_position = global_position + spawn_point
	bullet.direction = (
		player.global_position - bullet.global_position
	).normalized()
	
	get_parent().add_child(bullet)

func check_ataque():
	if animated_sprite.frame == 4 and not has_shot:
		has_shot = true
		dispara_bullet()
	var last_frame = animated_sprite.sprite_frames.get_frame_count("default") - 1
	
	if animated_sprite.frame >= last_frame:
		attack = false


func recibir_daño(golpe : int):
	if vida > 0:
		vida = vida - golpe
		print("La vida del policia es: ",vida)
	else:
		queue_free()
