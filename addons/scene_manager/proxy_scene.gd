class_name ProxyScene
extends CanvasLayer
"""
Proxy scene

Usage:
-right click on proxy_scene.tscn file in File System and choose New Inherited Scene

-right click on ProxyScene node (top one) and choose Extend Script to add additional funcionality to your scene

-add functionality in start() and end() functions in inherited scene
"""


signal scene_loaded(scene)
signal scene_unloaded(scene)


onready var id: String = filename


func load_scene(_id: String, params: Dictionary) -> void:
	id = _id
	
	start(params)
	emit_signal("scene_loaded", self)
	
	
func unload_scene() -> void:
	end()
	emit_signal("scene_unloaded", self)
	
	
func start(params: Dictionary) -> void:
	pass	#can override this
	
	
func end() -> void:
	pass	#can override this