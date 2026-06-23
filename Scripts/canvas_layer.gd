extends CanvasLayer

@onready var vida_container: HBoxContainer = $Control/MarginContainer/Vida/VBoxContainer/VidaContainer

var heart_texture = preload("res://Imagenes/Corazón.png")

func update_hearts(current_hp : int):
	for child in vida_container.get_children():
		child.queue_free()
	
	for i in range(current_hp):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		vida_container.add_child(heart)
