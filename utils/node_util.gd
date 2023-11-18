class_name NodeUtil
extends Object


static func custom_class_exist(custom_class_name: String) -> bool:
	var exist := false
	for x in ProjectSettings.get_global_class_list():
		if str(x["class"]) == custom_class_name:
			exist = true
			break
	return exist
	
	
static func get_custom_class_name_from_script(script: Script) -> String:
	var custom_class_name := ""
	if script != null:
		for x in ProjectSettings.get_global_class_list():
			if str(x["path"]) == script.resource_path:
				custom_class_name = str(x["class"])
				break
	return custom_class_name 
	
	
static func remove_children(node: Node, free_children: bool = false) -> void: # removes all children from a node, optionally freeing children
	for child in node.get_children():
		node.remove_child(child)
		if free_children:
			child.queue_free()
