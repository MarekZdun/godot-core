class_name FileUtil
extends Object


static func load_text(file_path: String, default_value: String = "") -> String:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return default_value
	var data = file.get_as_text()
	file.close()
	return data
	
	
static func load_encrypted_text(file_path: String, password: String = "pass",  default_value: String = "") -> String:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, password)
	if file == null:
		return default_value
	var data = file.get_as_text()
	file.close()
	return data


static func save_text(file_path: String, data: String) -> int:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(data)
	file.close()
	return OK
	
	
static func save_encrypted_text(file_path: String, data: String, password: String = "pass") -> int:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, password)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(data)
	file.close()
	return OK
		

static func load_encrypted_data(file_path: String, password: String = "pass", default_value = {}) -> Dictionary:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, password)
	if file == null:
		return default_value
	var data = file.get_var(false)
	file.close()
	return data

		
static func save_encrypted_data(file_path: String, data: Dictionary, password: String = "pass") -> int:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, password)
	if file == null:
		return FileAccess.get_open_error()
	file.store_var(data, false)
	file.close()
	return OK
	
	
static func load_encrypted_object(file_path: String, password: String = "pass", default_value = null) -> Object:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, password)
	if file == null:
		return default_value
	var data = file.get_var(true)
	file.close()
	return data

		
static func save_encrypted_object(file_path: String, data: Object, password: String) -> int:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, password)
	if file == null:
		return FileAccess.get_open_error()
	file.store_var(data, true)
	file.close()
	return OK
		
		
static func load_data_resource(file_path: String, default_value = null) -> Resource:
	if not ResourceLoader.exists(file_path):
		return default_value
	return ResourceLoader.load(file_path)
	
	
static func save_data_resource(file_path: String, data: Resource) -> int:
	return ResourceSaver.save(data, file_path)
	
	
static func load_data_JSON(file_path: String, default_value = {}) -> Dictionary:
	var json_text := load_text(file_path)
	if json_text.is_empty():
		return default_value
	var json := JSON.new()
	var err := json.parse(json_text)
	if err != OK:
		print("error parsing data: %s" % json.get_error_message())
		print(json.get_error_message())
		print(json.get_error_line())
		return default_value
	return json.data
	
	
static func load_encrypted_data_JSON(file_path: String, password: String = "pass", default_value = {}) -> Dictionary:
	var json_text := load_encrypted_text(file_path, password, default_value)
	if json_text.is_empty():
		return default_value
	var json := JSON.new()
	var err := json.parse(json_text)
	if err != OK:
		print("error parsing data: %s" % json.get_error_message())
		print(json.get_error_message())
		print(json.get_error_line())
		return default_value
	return json.data
	
	
static func save_data_JSON(file_path: String, data: Dictionary, indent: String = "") -> int:
	if not indent.is_empty():
		return save_text(file_path, JSON.stringify(data, indent))
	return save_text(file_path, JSON.stringify(data))
	
	
static func save_encrypted_data_JSON(file_path: String, data: Dictionary, password: String = "pass", indent: String = "") -> int:
	if not indent.is_empty():
		return save_encrypted_text(file_path, JSON.stringify(data, indent), password)
	return save_encrypted_text(file_path, JSON.stringify(data), password)
