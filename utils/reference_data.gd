class_name ReferenceData
extends Reference

export var filepath: String


func _init():
	filepath = get_script().resource_path
