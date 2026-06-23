extends Area2D


enum ItemType {
	TELEVISOR,
	CELULAR,
	PARLANTE,
	COBRE,
	ELECTRODIMESTICO
	
}

@export var icon: CompressedTexture2D
@export var item: ItemType


@onready var sprite: Sprite2D = $Sprite2D

var precio : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = icon
	actualizar_precio()
	randomize()


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




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		body.sumar_dinero(precio)
		queue_free()
