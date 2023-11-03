extends "res://addons/scene_manager/proxy_scene.gd"


signal exit_level()
signal change_level(next_level_filepath)

export(String, FILE, "*.tscn") var next_level_filepath: String

var runtime_res = preload("res://resources/runtime.tscn")

onready var player = $Movable


func _unhandled_input(event):	
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_ENTER:
			player.queue_free()
				
		elif event.scancode == KEY_1:
			emit_signal("change_level", next_level_filepath)
		
		elif event.scancode == KEY_ESCAPE:
			emit_signal("exit_level")
			
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var collider = detect_collider(event.position)
			
			if collider:
				collider.queue_free()
			else:
				var runtime = runtime_res.instance()
				runtime.setup(event.position)
				add_child(runtime)
	#			get_tree().set_input_as_handled()


func detect_collider(pos) -> Object:
	var collider = null
	for child in get_children():
		if child is Sprite:
			if child.get_rect().has_point(child.to_local(pos)):
				collider = child
				break
		
	return collider
	
	
func start(params: Dictionary) -> void:
	print(params)
