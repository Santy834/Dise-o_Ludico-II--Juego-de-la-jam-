extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/MENUS/Menu_Jugar.tscn")


func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/MENUS/Menu_Opciones.tscn")


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/MENUS/CREDITOS.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
