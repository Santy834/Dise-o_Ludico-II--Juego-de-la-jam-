extends Area2D

@export var speed := 600.0
var direction := Vector2.ZERO

func _physics_process(delta):

	global_position += direction * speed * delta
	
func _on_body_entered(body):

	if body.is_in_group("Policia"):

		body.recibir_daño(1)

	queue_free()
