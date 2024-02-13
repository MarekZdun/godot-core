class_name SmartJSONParser
extends Object


static func serialize_variant_data(variant) -> Dictionary:
	var variant_type: int = typeof(variant)
	var output_data: Dictionary
	if variant_type == TYPE_OBJECT:
		output_data = serialize_object_data(variant)
		
	elif variant_type == TYPE_DICTIONARY:
		output_data = serialize_dictionary_data(variant)
		
	elif variant_type == TYPE_ARRAY:
		output_data = serialize_array_data(variant)
		
	elif variant_type == TYPE_VECTOR2:
		output_data = serialize_vector2_data(variant)
		
	elif variant_type == TYPE_VECTOR3:
		output_data = serialize_vector3_data(variant)
		
	else:
		output_data = serialize_basic_data(variant)
	
	return output_data


static func serialize_object_data(obj: Object) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(obj),
		"value": {}
	}
	for prop in obj.get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name: String = prop.name
			var prop_value = obj.get(prop_name)
			
			if prop.type == TYPE_OBJECT:
				output_data.value[prop_name] = serialize_object_data(prop_value)
				
			elif prop.type == TYPE_DICTIONARY:
				output_data.value[prop_name] = serialize_dictionary_data(prop_value)
				
			elif prop.type == TYPE_ARRAY:
				output_data.value[prop_name] = serialize_array_data(prop_value)
				
			elif prop.type == TYPE_VECTOR2:
				output_data.value[prop_name] = serialize_vector2_data(prop_value)
				
			elif prop.type == TYPE_VECTOR3:
				output_data.value[prop_name] = serialize_vector3_data(prop_value)
				
			else:
				output_data.value[prop_name] = serialize_basic_data(prop_value)
	
	return output_data
	
	
static func serialize_dictionary_data(dic: Dictionary) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(dic),
		"value": {}
	}
	for key in dic:
		var value = dic[key]
		if typeof(value) == TYPE_OBJECT:
			output_data.value[key] = serialize_object_data(value)
			
		elif typeof(value) == TYPE_DICTIONARY:
			output_data.value[key] = serialize_dictionary_data(value)
			
		elif typeof(value) == TYPE_ARRAY:
			output_data.value[key] = serialize_array_data(value)
			
		elif typeof(value) == TYPE_VECTOR2:
			output_data.value[key] = serialize_vector2_data(value)
			
		elif typeof(value) == TYPE_VECTOR3:
			output_data.value[key] = serialize_vector3_data(value)
			
		else:
			output_data.value[key] = serialize_basic_data(value)
	
	return output_data
	
	
static func serialize_array_data(arr: Array) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(arr),
		"value": []
	}
	for i in range(arr.size()):
		var value = arr[i]
		if typeof(value) == TYPE_OBJECT:
			output_data.value.append(serialize_object_data(value))
		
		elif typeof(value) == TYPE_DICTIONARY:
			output_data.value.append(serialize_dictionary_data(value))
			
		elif typeof(value) == TYPE_ARRAY:
			output_data.value.append(serialize_array_data(value))
			
		elif typeof(value) == TYPE_VECTOR2:
			output_data.value.append(serialize_vector2_data(value))
			
		elif typeof(value) == TYPE_VECTOR3:
			output_data.value.append(serialize_vector3_data(value))
			
		else:
			output_data.value.append(serialize_basic_data(value))
	
	return output_data
	
	
static func serialize_vector2_data(vec2: Vector2) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(vec2),
		"value": {
			"x": vec2.x,
			"y": vec2.y
		}
	}
	
	return output_data
	
	
static func serialize_vector3_data(vec3: Vector3) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(vec3),
		"value": {
			"x": vec3.x,
			"y": vec3.y,
			"z": vec3.z
		}
	}
	
	return output_data
	
	
static func serialize_basic_data(basic) -> Dictionary:
	var output_data: Dictionary = {
		"type": typeof(basic),
		"value": basic
	}
	
	return output_data
	
	
static func deserialize_variant_data(text_data: Dictionary):
	var type: int = text_data.type
	var value = text_data.value
	var output_data
	if type == TYPE_OBJECT and "filepath" in value:
		output_data = deserialize_object_data(text_data)
		
	elif type == TYPE_DICTIONARY:
		output_data = deserialize_dictionary_data(text_data)
		
	elif type == TYPE_ARRAY:
		output_data = deserialize_array_data(text_data)
		
	elif type == TYPE_VECTOR2:
		output_data = deserialize_vector2_data(text_data)
		
	elif type == TYPE_VECTOR3:
		output_data = deserialize_vector3_data(text_data)
		
	else:
		output_data = value
	
	return output_data
	
	
static func deserialize_object_data(text_data: Dictionary) -> Object:
#	var type: int = text_data.type
	var value: Dictionary = text_data.value
	var output_data: Object
	var obj_res := load(value.filepath.value)
	output_data = obj_res.new() as Object
	
	for prop_name in value:
		var prop_value = value[prop_name].value
		var prop_type: int = value[prop_name].type

		if prop_type == TYPE_OBJECT and "filepath" in prop_value:
			output_data.set(prop_name, deserialize_object_data(value[prop_name]))
			
		elif prop_type == TYPE_DICTIONARY:
			output_data.set(prop_name, deserialize_dictionary_data(value[prop_name]))
			
		elif prop_type == TYPE_ARRAY:
			output_data[prop_name].assign(deserialize_array_data(value[prop_name]))
			
		elif prop_type == TYPE_VECTOR2:
			output_data.set(prop_name, deserialize_vector2_data(value[prop_name]))
			
		elif prop_type == TYPE_VECTOR3:
			output_data.set(prop_name, deserialize_vector3_data(value[prop_name]))
			
		else:
			output_data.set(prop_name, prop_value)
	
	return output_data
	
	
static func deserialize_dictionary_data(text_data: Dictionary) -> Dictionary:
#	var type: int = text_data.type
	var value: Dictionary = text_data.value
	var output_data: Dictionary
	for prop_name in value:
		var prop_value = value[prop_name].value
		var prop_type = value[prop_name].type

		if prop_type == TYPE_OBJECT and "filepath" in prop_value:
			output_data[prop_name] = deserialize_object_data(value[prop_name])
			
		elif prop_type == TYPE_DICTIONARY:
			output_data[prop_name] = deserialize_dictionary_data(value[prop_name])
			
		elif prop_type == TYPE_ARRAY:
			output_data[prop_name].assign(deserialize_array_data(value[prop_name]))
			
		elif prop_type == TYPE_VECTOR2:
			output_data[prop_name] = deserialize_vector2_data(value[prop_name])
			
		elif prop_type == TYPE_VECTOR3:
			output_data[prop_name] = deserialize_vector3_data(value[prop_name])
			
		else:
			output_data[prop_name] = prop_value
	
	return output_data
	
	
static func deserialize_array_data(text_data: Dictionary) -> Array:
#	var type: int = text_data.type
	var value: Array = text_data.value
	var output_data: Array
	for i in range(value.size()):
		var prop_value = value[i].value
		var prop_type = value[i].type
		
		if prop_type == TYPE_OBJECT and "filepath" in prop_value:
			output_data.append(deserialize_object_data(value[i]))
			
		elif prop_type == TYPE_DICTIONARY:
			output_data.append(deserialize_dictionary_data(value[i]))
			
		elif prop_type == TYPE_ARRAY:
			var arr := []
			arr.assign(deserialize_array_data(value[i]))
			output_data.append(arr)
			
		elif prop_type == TYPE_VECTOR2:
			output_data.append(deserialize_vector2_data(value[i]))
			
		elif prop_type == TYPE_VECTOR3:
			output_data.append(deserialize_vector3_data(value[i]))
			
		else:
			output_data.append(prop_value)
	
	return output_data
	
	
static func deserialize_vector2_data(text_data: Dictionary) -> Vector2:
#	var type: int = text_data.type
	var value: Dictionary = text_data.value
	return Vector2(value.x, value.y)
	
	
static func deserialize_vector3_data(text_data: Dictionary) -> Vector3:
#	var type: int = text_data.type
	var value: Dictionary = text_data.value
	return Vector3(value.x, value.y, value.z)
