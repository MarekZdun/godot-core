class_name SmartReference
extends Reference

export var filepath: String


func _init():
	filepath = get_script().resource_path
