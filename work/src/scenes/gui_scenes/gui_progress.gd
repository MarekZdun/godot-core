extends ProxyGui


onready var progress_bar = get_node("Root/ProgressBar")


func update_progress_bar(progress: float) -> void:
	progress_bar.value = progress * 100
	
	
func reset_progress_bar() -> void:
	progress_bar.value = 0
	
	
func _on_progress_changed(progress: float):
	update_progress_bar(progress)

