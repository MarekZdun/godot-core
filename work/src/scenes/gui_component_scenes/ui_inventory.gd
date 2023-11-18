extends Control

const ui_item_scene := preload("ui_item.tscn")

# This menu displays the content of this inventory resource. Clicking the 
# buttons to add or remove items directly removes them from this resource.
var inventory_data: InventoryData = null: set = set_inventory_data

@onready var ui_tooltip := $UITooltip
@onready var item_grid := $MarginContainer/VBoxContainer/ItemGrid
@onready var add_item_button := $MarginContainer/VBoxContainer/HBoxContainer/AddItemButton
@onready var remove_item_button := $MarginContainer/VBoxContainer/HBoxContainer/RemoveItemButton


func _ready() -> void:
	# If running the scene with F6, we create an inventory for testing purposes.
	if get_parent() == get_tree().root:
		var test_inventory_data := InventoryData.new()
		test_inventory_data.add_item("long_sword", 1)
		test_inventory_data.add_item("short_sword", 2)
		set_inventory_data(test_inventory_data)

	add_item_button.pressed.connect(_add_random_item)
	remove_item_button.pressed.connect(_remove_random_item)


func set_inventory_data(new_inventory_data: InventoryData) -> void:
	if inventory_data != new_inventory_data:
		new_inventory_data.changed.connect(_update_items_display)

	inventory_data = new_inventory_data
	_update_items_display()


func _update_items_display() -> void:
	for node in item_grid.get_children():
		node.queue_free()
	
	for item_unique_id in inventory_data.items:
		var ui_item: UIItem = ui_item_scene.instantiate()
		item_grid.add_child(ui_item)
		ui_item.display_item(item_unique_id, inventory_data.get_amount(item_unique_id))
		ui_item.tooltip_requested.connect(_on_tooltip_requested.bind(ui_item))


func _on_tooltip_requested(ui_item: UIItem) -> void:
	var description := ItemDatabase.get_item_data(ui_item.item_unique_id).description
	ui_tooltip.display(description, get_global_mouse_position())


func _add_random_item() -> void:
	var item_unique_id: String = ItemDatabase.ITEMS.keys()[randi() % ItemDatabase.ITEMS.keys().size()]
	inventory_data.add_item(item_unique_id)


func _remove_random_item() -> void:
	if inventory_data.items:
		inventory_data.remove_item(inventory_data.items.keys()[randi() % inventory_data.items.keys().size()])
