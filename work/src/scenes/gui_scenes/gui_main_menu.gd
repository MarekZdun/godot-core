extends ProxyGui


signal button_play_game_click()


func _on_PlayGame_pressed():
	button_play_game_click.emit()
