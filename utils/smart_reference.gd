class_name SmartReference
extends RefCounted

@export var filepath: String


func _init():
	filepath = get_script().resource_path
