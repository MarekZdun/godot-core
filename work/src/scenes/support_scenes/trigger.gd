extends Node

signal trigger_to_color(color)

@export var trigger_id: String = ""

var triggered: bool = false: set = _set_triggered


func _unhandled_input(event):	
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_SPACE:
			triggered = !triggered
			
			
func get_color() -> Color:
	var output_color: Color
	if triggered:
		output_color = Color.RED
	else:
		output_color = Color.WHITE
	
	return output_color
				
				
func _set_triggered(_triggered: bool):
	triggered = _triggered
	trigger_to_color.emit(get_color())
	
	
func _on_GameStateHelper_loading_data(data):
	if data.has(trigger_id):
		triggered = data[trigger_id]
		
		
func _on_GameStateHelper_saving_data(data):
	if trigger_id.is_empty():
		printerr("Trigger: unable to save data - no trigger id.  %s" % get_path())
		return
	data[trigger_id] = triggered
