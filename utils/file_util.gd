class_name FileUtil
extends Object


static func load_text(file_path: String, default_value: String = "") -> String:
	var file: File = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK:
		file.close()
		return default_value
	var data = file.get_as_text()
	file.close()
	return data
	
	
static func load_encrypted_text(file_path: String, password: String = "pass",  default_value: String = "") -> String:
	var file: File = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.READ, password)
	if error != OK:
		file.close()
		return default_value
	var data = file.get_as_text()
	file.close()
	return data


static func save_text(file_path: String, data: String) -> int:
	var file: File = File.new()
	var error = file.open(file_path, File.WRITE)
	if error != OK:
		file.close()
		return error
	file.store_string(data)
	file.close()
	return OK
	
	
static func save_encrypted_text(file_path: String, data: String, password: String = "pass") -> int:
	var file: File = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.WRITE, password)
	if error != OK:
		file.close()
		return error
	file.store_string(data)
	file.close()
	return OK
		

static func load_encrypted_data(file_path: String, password: String = "pass", default_value = {}) -> Dictionary:
	var file = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.READ, password)
	if error != OK:
		file.close()
		return default_value
	var data = file.get_var(false)
	file.close()
	return data

		
static func save_encrypted_data(file_path: String, data: Dictionary, password: String = "pass") -> int:
	var file = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.WRITE, password)
	if error != OK:
		file.close()
		return error
	file.store_var(data, false)
	file.close()
	return OK
	
	
static func load_encrypted_object(file_path: String, password: String = "pass", default_value = null) -> Object:
	var file = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.READ, password)
	if error != OK:
		file.close()
		return default_value
	var data = file.get_var(true)
	file.close()
	return data

		
static func save_encrypted_object(file_path: String, data: Object, password: String) -> int:
	var file = File.new()
	var error = file.open_encrypted_with_pass(file_path, File.WRITE, password)
	if error != OK:
		file.close()
		return error
	file.store_var(data, true)
	file.close()
	return OK
		
		
static func load_data_resource(file_path: String, default_value = null) -> Resource:
	if !ResourceLoader.exists(file_path):
		return default_value

	if ResourceLoader.has_cached(file_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the save game.
		return ResourceLoader.load(file_path, "", true)

	# /!\ Workaround for bug https://github.com/godotengine/godot/issues/59686
	# Without that, sub-resources will not reload from the saved data.
	# We copy the SaveGame resource's data to a temporary file, load that file
	# as a resource, and make it take over the save game.

	# We first load the save game resource's content as a byte array and store it.
	var file := File.new()
	if file.open(file_path, File.READ) != OK:
		printerr("Couldn't read file " + file_path)
		return default_value

	var data := file.get_buffer(file.get_len())
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the save game to that temporary file path.
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return default_value

	file.store_buffer(data)
	file.close()

	# We load the temporary file as a resource.
	var save = ResourceLoader.load(tmp_file_path, "", true)
	# And make it take over the save path for the next time the player
	# saves.
	save.take_over_path(file_path)

	# We delete the temporary file.
	var directory := Directory.new()
	directory.remove(tmp_file_path)
	return save
	
	
static func save_data_resource(file_path: String, data: Resource) -> int:
	return ResourceSaver.save(file_path, data)
	
	
static func load_data_JSON(file_path: String, default_value = {}) -> Dictionary:
	var json_text = load_text(file_path)
	if json_text == "":
		return default_value
	var json_data = JSON.parse(json_text)
	if json_data.error != OK:
		print("error parsing data: %s" % json_data.error_string)
		print(json_data.error_string)
		print(json_data.error_line)
		return default_value
	return json_data.result
	
	
static func load_encrypted_data_JSON(file_path: String, password: String = "pass", default_value = {}) -> Dictionary:
	var json_text = load_encrypted_text(file_path, password, default_value)
	if json_text == "":
		return default_value
	var json_data = JSON.parse(json_text)
	if json_data.error != OK:
		print("error parsing data: %s" % json_data.error_string)
		print(json_data.error_string)
		print(json_data.error_line)
		return default_value
	return json_data.result
	
	
static func save_data_JSON(file_path: String, data: Dictionary, indent: String = "") -> int:
	if indent != "":
		return save_text(file_path, JSON.print(data, indent))
	return save_text(file_path, to_json(data))
	
	
static func save_encrypted_data_JSON(file_path: String, data: Dictionary, password: String = "pass", indent: String = "") -> int:
	if indent != "":
		return save_encrypted_text(file_path, JSON.print(data, indent), password)
	return save_encrypted_text(file_path, to_json(data), password)
	
	
static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"
