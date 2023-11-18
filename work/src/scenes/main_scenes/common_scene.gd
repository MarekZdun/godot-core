extends ProxyScene

signal exit_level()
signal change_level(next_level_filepath)

enum LevelKeys{LEVEL_KEY_NONE = 0, LEVEL_KEY_1 = KEY_1, LEVEL_KEY_2 = KEY_2}

@export_file("*.tscn") var next_level_filepath: String
@export_file("*.tscn") var runtime_collectable_filepath: String
@export_file("*.tscn") var runtime_collectable_trap_filepath: String
@export_file("*.tscn") var runtime_trap_filepath: String
@export var next_level_actor_start_pos: Vector2
@export var next_level_key: LevelKeys

var runtimes: Array 

@onready var actor = $Movable


func _ready():
	await GameStateService.state_load_completed
	
	if not runtime_collectable_filepath.is_empty():
		runtimes.append(load(runtime_collectable_filepath))
		
	if not runtime_collectable_trap_filepath.is_empty():
		runtimes.append(load(runtime_collectable_trap_filepath))
		
	if not runtime_trap_filepath.is_empty():
		runtimes.append(load(runtime_trap_filepath))
	
	var actor_start_pos = GameStateService.get_global_state_value("actor_start_pos")
	if actor_start_pos == null:
		return
		
	actor.global_position = actor_start_pos
	GameStateService.set_global_state_value("actor_start_pos", null)


func _unhandled_input(event):	
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_ENTER:
#			actor.queue_free()
			pass
		
		elif event.keycode == next_level_key:
			GameStateService.set_global_state_value("actor_start_pos", next_level_actor_start_pos)
			change_level.emit(next_level_filepath)
		
		elif event.keycode == KEY_ESCAPE:
			exit_level.emit()
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var collider = detect_collider(event.position)
			
			if collider:
				collider.queue_free()
			else:
				var runtime_res: PackedScene = runtimes[randi() % runtimes.size()] if runtimes.size() > 0 else null
				if runtime_res:
					var runtime: Node = runtime_res.instantiate()
					runtime.setup(event.global_position)
					add_child(runtime)


func detect_collider(pos) -> Object:
	var collider = null
	for child in get_children():
		if child is Sprite2D:
			if child.get_rect().has_point(child.to_local(pos)):
				collider = child
				break
		
	return collider
