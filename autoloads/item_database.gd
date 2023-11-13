extends Node
#Remember to set _items_folder_path in static function!

# Maps unique IDs of items to ItemData instances.
var ITEMS := {}


func _ready() -> void:
	var items := _load_items()
	for item in items:
		ITEMS[item.unique_id] = item


func get_item_data(unique_id: String) -> ItemData:
	if not unique_id in ITEMS:
		printerr("Trying to get nonexistent item %s in items database" % unique_id)
		return null
	
	return ITEMS[unique_id]


static func _load_items() -> Array:
	var item_file_paths := []
	var _items_folder_path := "res://work/src/resources/item_data/"

	var directory := Directory.new()
	var can_continue := directory.open(_items_folder_path) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [_items_folder_path])
		return item_file_paths

	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			item_file_paths.append(_items_folder_path.plus_file(file_name))
		file_name = directory.get_next()

	var item_resources := []
	for path in item_file_paths:
		item_resources.append(load(path))

	# Ensure each loaded item has valid data in debug builds.
	if OS.is_debug_build():
		var ids := []
		var bad_items := []
		for item in item_resources:
			if item.unique_id in ids:
				bad_items.append(item)
			else:
				ids.append(item.unique_id)
		for item in bad_items:
			printerr("Item %s has a non-unique ID: %s" % [item.display_name, item.unique_id])

	return item_resources
