extends ProxyGui

@onready var ui_info_display = $Root/UIInfoDisplay
@onready var ui_inventory = $Root/UIInventory
@onready var scene_id_lab = $Root/SceneIdLab
@onready var game_play_info_lab = $Root/GamePlayInfoLab
@onready var scene_info_lab = $Root/SceneInfoLab


func set_scene_id_lab_text(text: String) -> void:
	scene_id_lab.text = text


func set_scene_id_lab_color(color: Color) -> void:
	scene_id_lab.modulate = color
	
	
func set_scene_info_lab_text(text: String) -> void:
	scene_info_lab.text = text
