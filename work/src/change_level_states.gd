class_name ChangeLevelStates


#---------------------------------------------------------------------------------------------------

class IdleState extends StateMachine.State:
	func _init():
		physics_process_enabled = false
	
	
	func _process(_delta: float):
		pass


	func _on_enter_state():
		pass
	
	
	func _on_leave_state():
		pass
		
#---------------------------------------------------------------------------------------------------

class CurtainAppearState extends StateMachine.State:
	var gui_curtain_loaded: bool = false


	func _init():
		physics_process_enabled = false
		input_enabled = false
		
		
	func _process(_delta: float):
		if gui_curtain_loaded:
			gui_curtain_loaded = false
			
			state_machine.get_ref().transition("progress_appear")
		
		
	func _on_enter_state():
		var gui_curtain_id = GuiManager.add_gui("gui_curtain", 1, {
			"transition_name": "fade",
			"transition_out": false,
			"duration": 1,
			"gui_opacity_start": 0.0,
			"gui_opacity_end": 1.0
		})
		target.main.gui_curtain = GuiManager.get_gui(gui_curtain_id)
		
		GuiManager.connect("manager_gui_loaded", self, "_on_gui_on_screen")
		
		
	func _on_leave_state():
		GuiManager.disconnect("manager_gui_loaded", self, "_on_gui_on_screen")
		
		if is_instance_valid(target.main.gui_main_menu):
			GuiManager.destroy_gui(target.main.gui_main_menu.id)


	func _on_gui_on_screen(gui):
		if gui.id == target.main.gui_curtain.id:
			gui_curtain_loaded = true
		
#---------------------------------------------------------------------------------------------------

class ProgressAppearState extends StateMachine.State:
	var gui_progress_loaded: bool = false


	func _init():
		physics_process_enabled = false
		input_enabled = false
		
		
	func _process(_delta: float):
		if gui_progress_loaded:
			gui_progress_loaded = false
			
			state_machine.get_ref().transition("load_level")
		
		
	func _on_enter_state():
		var gui_progress_id = GuiManager.add_gui_above_top_one("gui_progress", {
			"transition_name": "fade",
			"transition_out": false,
			"duration": 1,
			"gui_opacity_start": 0.0,
			"gui_opacity_end": 1.0
		})
		target.main.gui_progress = GuiManager.get_gui(gui_progress_id)
		
		GuiManager.connect("manager_gui_loaded", self, "_on_gui_on_screen")
		
		
	func _on_leave_state():
		GuiManager.disconnect("manager_gui_loaded", self, "_on_gui_on_screen")


	func _on_gui_on_screen(gui):
		if gui.id == target.main.gui_progress.id:
			gui_progress_loaded = true
		
#---------------------------------------------------------------------------------------------------

class CurtainDisappearState extends StateMachine.State:
	var gui_curtain_unloaded: bool = false


	func _init():
		physics_process_enabled = false
		input_enabled = false
		
		
	func _process(_delta: float):
		if gui_curtain_unloaded:
			gui_curtain_unloaded = false
			
			state_machine.get_ref().transition("finish_level_load")
		
		
	func _on_enter_state():
		GuiManager.destroy_gui(target.main.gui_curtain.id, {
			"transition_name": "fade",
			"transition_out": true,
			"duration": 1,
			"gui_opacity_start": 1.0,
			"gui_opacity_end": 0.0
		})
		
		GuiManager.connect("manager_gui_unloaded", self, "_on_gui_off_screen")
		
		
	func _on_leave_state():
		GuiManager.disconnect("manager_gui_unloaded", self, "_on_gui_off_screen")


	func _on_gui_off_screen(gui_id):
		if gui_id == target.main.gui_curtain.id:
			gui_curtain_unloaded = true
		
#---------------------------------------------------------------------------------------------------

class ProgressDisappearState extends StateMachine.State:
	var gui_progress_unloaded: bool = false


	func _init():
		physics_process_enabled = false
		input_enabled = false
		
		
	func _process(_delta: float):
		if gui_progress_unloaded:
			gui_progress_unloaded = false
			
			state_machine.get_ref().transition("curtain_disappear")
		
		
	func _on_enter_state():
		GuiManager.destroy_gui(target.main.gui_progress.id, {
			"transition_name": "fade",
			"transition_out": true,
			"duration": 1,
			"gui_opacity_start": 1.0,
			"gui_opacity_end": 0.0
		})
		
		GuiManager.connect("manager_gui_unloaded", self, "_on_gui_off_screen")
		
		
	func _on_leave_state():
		GuiManager.disconnect("manager_gui_unloaded", self, "_on_gui_off_screen")


	func _on_gui_off_screen(gui_id):
		if gui_id == target.main.gui_progress.id:
			gui_progress_unloaded = true
		
#---------------------------------------------------------------------------------------------------

class LoadLevelState extends StateMachine.State:
	var scene_loaded: bool = false
	var scene: Node


	func _init():
		physics_process_enabled = false
		input_enabled = false
		
		
	func _process(_delta: float):
		if scene_loaded:
			scene_loaded = false
			
			if target.main.gui_hud == null or not is_instance_valid(target.main.gui_hud):
				var gui_hud_id = GuiManager.add_gui("gui_hud", 0)
				target.main.gui_hud = GuiManager.get_gui(gui_hud_id)
				
			target.main.gui_hud.ui_inventory.inventory_data = GameStateService.get_global_state_value("inventory_data")
				
			if scene.has_method("setup_hud"):
				scene.setup_hud(target.main.gui_hud)
			
			state_machine.get_ref().transition("progress_disappear")


	func _on_enter_state():
		SceneManager.connect("manager_scene_loaded", target.main, "_on_scene_ready")
		SceneManager.connect("manager_scene_loaded", self, "_on_scene_ready")
		SceneManager.get_node("ResourceLoaderInteractive").connect("update_progress", target.main.gui_progress, "_on_progress_changed")
		SceneManager.get_node("ResourceLoaderMultithread").connect("update_progress", target.main.gui_progress, "_on_progress_changed")
		
		SceneManager.change_scene(target.main.next_scene_id)
		
		
	func _on_leave_state():
		SceneManager.disconnect("manager_scene_loaded", target.main, "_on_scene_ready")
		SceneManager.disconnect("manager_scene_loaded", self, "_on_scene_ready")
		SceneManager.get_node("ResourceLoaderInteractive").disconnect("update_progress", target.main.gui_progress, "_on_progress_changed")
		SceneManager.get_node("ResourceLoaderMultithread").disconnect("update_progress", target.main.gui_progress, "_on_progress_changed")


	func _on_scene_ready(p_scene: Node):
		scene = p_scene
		scene_loaded = true
		
#---------------------------------------------------------------------------------------------------

class FinishLoadLevelState extends StateMachine.State:
	func _init():
		physics_process_enabled = false
	
	
	func _process(_delta: float):
		pass


	func _on_enter_state():
		target.emit_signal("level_changed")
	
	
	func _on_leave_state():
		pass
		
#---------------------------------------------------------------------------------------------------
