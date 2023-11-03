extends Node


export var trigger_id: String = ""

var triggered: bool = false setget _set_triggered


func _ready():
	_set_triggered(false)


func _unhandled_input(event):	
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_SPACE:
			self.triggered = !triggered
				
				
func _set_triggered(_triggered: bool):
	triggered = _triggered
	
	var color = Color.red if triggered else Color.white
	self.modulate = color
	
	
func _on_GameStateHelper_loading_data(data):
	if data.has(trigger_id):
		self.triggered = data[trigger_id]
		
		
func _on_GameStateHelper_saving_data(data):
	if trigger_id.empty():
		printerr("Trigger: unable to save data - no trigger id.  %s" % get_path())
		return
	data[trigger_id] = triggered
