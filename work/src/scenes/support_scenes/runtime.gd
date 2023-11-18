extends Sprite2D

@export var start_stats: Resource

var stats: RuntimeResource: set = set_stats


func setup(pos: Vector2):
	if start_stats != null:
		var _stats := RuntimeResource.new()
		_stats.display_name = start_stats.display_name
		_stats.global_position = pos
		_stats.reward = start_stats.reward
		_stats.damage = start_stats.damage
		stats = _stats
	
	
func set_stats(new_stats: RuntimeResource) -> void:
	stats = new_stats
	global_position = stats.global_position
	set_process(stats != null)


func _on_Area2D_area_entered(area):
	var node: Node = area.get_parent()
	if node and node.is_in_group("actor"):
		queue_free()
