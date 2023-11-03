class_name ResourceData
extends Resource

export var filepath: String


func _init():
	filepath = get_script().resource_path
