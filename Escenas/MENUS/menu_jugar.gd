extends Control



func _on_new_game_btn_pressed() -> void:
	GameManager.vida_pj = 5
	get_tree().change_scene_to_file("res://Escenas/Mundo.tscn")


func _on_selct_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_jugar.tscn")

func _on_volver_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/MENUS/menu_principal.tscn")
