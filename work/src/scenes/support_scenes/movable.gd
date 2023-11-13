extends KinematicBody2D

var stats: ActorResource setget set_stats


func _ready() -> void:
	set_process(false)


func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		velocity.y -= 1
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		velocity.y += 1
		
	move_and_slide(velocity.normalized() * stats.run_speed)
	
	stats.global_position = global_position


func set_stats(new_stats: ActorResource) -> void:
	stats = new_stats
	global_position = stats.global_position
	set_process(stats != null)


func _on_Area2D_area_entered(area):
	var node: Node = area.get_parent()
	
	if node and node.get("stats"):
		if node.is_in_group("collectable"):
			stats.reward_runtime_collected += node.stats.reward

		if node.is_in_group("trap"):
			stats.health = max(stats.health - node.stats.damage, 0)
