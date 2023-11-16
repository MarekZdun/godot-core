class_name MainStates


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

class MainMenuState extends StateMachine.State:
	var button_play_menu_clicked: bool = false


	func _init():
		physics_process_enabled = false
		
		
	func _input(event):
		if event is InputEventKey and event.pressed and not event.is_echo():
			if event.scancode == KEY_ESCAPE:
				target.get_tree().quit()
				
			elif event.shift and event.scancode == KEY_L:
				state_machine.get_ref().transition("load_saved_level")
		
		
	func _process(_delta: float):
		if button_play_menu_clicked:
			button_play_menu_clicked = false
			
			var viewport_size: Vector2 = target.get_viewport().size
			var inventory_data := InventoryData.new()
			inventory_data.add_item("long_sword", 3)
			inventory_data.add_item("short_sword", 1)
			target.next_scene_id = "res://work/src/scenes/main_scenes/scene_1.tscn"
			GameStateService.new_game()
			GameStateService.set_global_state_value("stats", ActorResource.new())
			GameStateService.set_global_state_value("actor_start_pos", Vector2(viewport_size.x/2, viewport_size.y/2))
			GameStateService.set_global_state_value("inventory_data", inventory_data)
			
			state_machine.get_ref().transition("change_level")
		
		
	func _on_enter_state():
		target.gui_main_menu = GuiManager.get_gui(GuiManager.add_gui("gui_main_menu", 1, {}))
		target.gui_main_menu.connect("button_play_game_click", self, "_on_button_play_game_clicked")

		
	func _on_leave_state():
		target.gui_main_menu.disconnect("button_play_game_click", self, "_on_button_play_game_clicked")


	func _on_button_play_game_clicked():
		button_play_menu_clicked = true

#---------------------------------------------------------------------------------------------------

class ChangeLevelState extends StateMachine.State:
	var change_level: ChangeLevel = null
	var level_changed: bool = false


	func _init():
#		physics_process_enabled = false
#		input_enabled = false
		pass
		
		
	func _input(event):
		pass
		
		
	func _process(_delta: float):
		if level_changed:
			level_changed = false
			
			state_machine.get_ref().transition("play_level")
		
		
	func _on_enter_state():
		change_level = ChangeLevel.new(target)
		target.add_child(change_level)
		change_level.connect("level_changed", self, "_on_level_changed")
		
		
	func _on_leave_state():
		change_level.disconnect("level_changed", self, "_on_level_changed")
		change_level.queue_free()
		

	func _on_level_changed():
		level_changed = true

#---------------------------------------------------------------------------------------------------

class PlayLevelState extends StateMachine.State:
	var exit_level: bool = false
	var go_to_next_level: bool = false


	func _init():
		physics_process_enabled = false
#		input_enabled = false


	func _input(event):
		if event is InputEventKey and event.pressed:
			if event.shift and event.scancode == KEY_S:
				target.save_game()
				
			elif event.shift and event.scancode == KEY_L:
				state_machine.get_ref().transition("load_saved_level")
		
		
	func _process(_delta: float):
		if exit_level:
			exit_level = false
			
			SceneManager.change_scene("")
			GuiManager.destroy_gui(target.gui_hud.id)
			
			state_machine.get_ref().transition("main_menu")
			
		if go_to_next_level:
			go_to_next_level = false
			
			state_machine.get_ref().transition("change_level")
		
		
	func _on_enter_state():
		SceneManager.current_scene.connect("exit_level", self, "_on_exit_level")
		SceneManager.current_scene.connect("change_level", self, "_on_change_to_next_level")
		
		
	func _on_leave_state():
		SceneManager.current_scene.disconnect("exit_level", self, "_on_exit_level")
		SceneManager.current_scene.disconnect("change_level", self, "_on_change_to_next_level")


	func _on_exit_level():
		exit_level = true
		
		
	func _on_change_to_next_level(next_scene_filepath: String):
		target.next_scene_id = next_scene_filepath
		go_to_next_level = true

#---------------------------------------------------------------------------------------------------

class LoadSavedLevelState extends StateMachine.State:
	var load_saved_level: LoadSavedLevel
	var level_loaded: bool = false

	func _init():
#		physics_process_enabled = false
#		input_enabled = false
		pass


	func _input(event):
		pass
		
		
	func _process(_delta: float):
		if level_loaded:
			level_loaded = false
			
			state_machine.get_ref().transition("play_level")
		
		
	func _on_enter_state():
		load_saved_level = LoadSavedLevel.new(target)
		target.add_child(load_saved_level)
		load_saved_level.connect("level_loaded", self, "_on_level_loaded")
		
		
	func _on_leave_state():
		load_saved_level.disconnect("level_loaded", self, "_on_level_loaded")
		load_saved_level.queue_free()
		
		
	func _on_level_loaded():
		level_loaded = true

#---------------------------------------------------------------------------------------------------
