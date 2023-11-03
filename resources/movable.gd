extends KinematicBody2D


var speed = 200


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
		
	move_and_slide(velocity.normalized() * speed)

func _draw():
	var size = get_viewport_rect().size
	draw_circle(Vector2(size.x/2, size.y/2), 25, Color(0.1, 0.5, 1))

