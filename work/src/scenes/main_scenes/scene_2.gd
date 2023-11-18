extends "res://work/src/scenes/main_scenes/common_scene.gd"

@onready var trigger = $Trigger


func setup_hud(gui_hud: Node) -> void:
	if gui_hud != null:
		trigger.trigger_to_color.connect(gui_hud.set_scene_id_lab_color)
		gui_hud.set_scene_id_lab_color(trigger.get_color())
		gui_hud.set_scene_id_lab_text(id)
		gui_hud.set_scene_info_lab_text("press 1 to go to level 1".to_upper())
		gui_hud.ui_info_display.actor_stats = actor.stats
