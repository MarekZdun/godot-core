class_name ChangeLevel
extends Node


signal level_changed()

var state_machine: StateMachine
var main: Node


func _init(_main: Node):
	if _main:
		main = _main
		state_machine = main.smf.create({
			"target": self,
			"current_state": "idle",
			"states": [
				{"id": "idle", "state": ChangeLevelStates.IdleState},
				{"id": "curtain_appear", "state": ChangeLevelStates.CurtainAppearState},
				{"id": "progress_appear", "state": ChangeLevelStates.ProgressAppearState},
				{"id": "curtain_disappear", "state": ChangeLevelStates.CurtainDisappearState},
				{"id": "progress_disappear", "state": ChangeLevelStates.ProgressDisappearState},
				{"id": "load_level", "state": ChangeLevelStates.LoadLevelState},
				{"id": "finish_level_load", "state": ChangeLevelStates.FinishLoadLevelState},
			],
			"transitions": [
				{"state_id": "idle", "to_states": ["curtain_appear"]},
				{"state_id": "curtain_appear", "to_states": ["progress_appear"]},
				{"state_id": "progress_appear", "to_states": ["load_level"]},
				{"state_id": "load_level", "to_states": ["progress_disappear"]},
				{"state_id": "progress_disappear", "to_states": ["curtain_disappear"]},
				{"state_id": "curtain_disappear", "to_states": ["finish_level_load"]},
				{"state_id": "finish_level_load", "to_states": []},
			]
		})
		
		state_machine.transition("curtain_appear")
		
		
func _input(event):
	state_machine._input(event)
	

func _process(delta):
	state_machine._process(delta)
