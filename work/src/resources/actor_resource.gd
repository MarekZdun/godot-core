class_name ActorResource
extends SmartResource

signal health_changed(health)
signal runtime_collected(runtime_reward)
signal global_position_changed(global_position)

@export var display_name := "Actor"
@export var global_position: Vector2: set = set_global_position
@export var run_speed := 600.0
@export var level := 1
@export var experience := 0
@export var health := 100: set = set_health
@export var reward_runtime_collected := 0: set = set_reward_runtime_collected
@export var strength := 5
@export var endurance := 5
@export var intelligence := 5


func set_health(new_health: int) -> void:
	health = new_health
	health_changed.emit(health)
	
	
func set_reward_runtime_collected(new_reward_runtime_collected: int) -> void:
	reward_runtime_collected = new_reward_runtime_collected
	runtime_collected.emit(reward_runtime_collected)
	
	
func set_global_position(new_global_position: Vector2) -> void:
	global_position = new_global_position
	global_position_changed.emit(new_global_position)
