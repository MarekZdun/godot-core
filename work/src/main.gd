extends Node


const SAVE_GAME_FOLDER = "user://save_games"

@export var window_manager: Resource

var next_scene_id: String
var state_machine: StateMachine

var gui_main_menu: CanvasLayer
var gui_curtain: CanvasLayer
var gui_progress: CanvasLayer
var gui_hud: CanvasLayer

@onready var active_scene_container = $ActiveSceneContainer
@onready var smf = StateMachineFactory.new()


func _ready():
	randomize()
	
	WindowManager.load(window_manager)
	
	SceneManager.scene_transitioning.connect(GameStateService.on_scene_transitioning)
	
	state_machine = smf.create({
		"target": self,
		"current_state": "idle",
		"states": [
			{"id": "idle", "state": MainStates.IdleState},
			{"id": "main_menu", "state": MainStates.MainMenuState},
			{"id": "change_level", "state": MainStates.ChangeLevelState},
			{"id": "play_level", "state": MainStates.PlayLevelState},
			{"id": "load_saved_level", "state": MainStates.LoadSavedLevelState},
		],
		"transitions": [
			{"state_id": "idle", "to_states": ["main_menu"]},
			{"state_id": "main_menu", "to_states": ["change_level", "load_saved_level"]},
			{"state_id": "change_level", "to_states": ["play_level"]},
			{"state_id": "play_level", "to_states": ["main_menu", "change_level", "load_saved_level"]},
			{"state_id": "load_saved_level", "to_states": ["play_level"]},
		]
	})
	
	if SceneManager.current_scene is Node:
		next_scene_id = SceneManager.current_scene.id
		state_machine.transition("play_level")
	else:
		state_machine.transition("main_menu")


func _input(event):
	state_machine._input(event)
	

func _process(delta):
	state_machine._process(delta)
		
		
func save_game():
	DirAccess.make_dir_recursive_absolute(SAVE_GAME_FOLDER)
	var save_game_file_name := SAVE_GAME_FOLDER.path_join("save.tres")
	GameStateService.save_game_state(save_game_file_name)


func _on_scene_ready(scene: Node):
	print("scene " + scene.id + " is ready")


func _on_scene_gone(scene_id: String):
	print("scene " + scene_id + " has gone")
