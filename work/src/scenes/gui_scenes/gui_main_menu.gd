extends ProxyGui


signal button_play_game_click()


func _on_PlayGame_pressed():
	emit_signal("button_play_game_click")
