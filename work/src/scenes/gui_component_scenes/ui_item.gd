class_name UIItem
extends Control

signal tooltip_requested()

var item_unique_id := ""

@onready var tooltip_timer := $TooltipTimer
@onready var texture_rect := $MarginContainer/HBoxContainer/TextureRect
@onready var name_label := $MarginContainer/HBoxContainer/NameLabel
@onready var amount_label := $MarginContainer/HBoxContainer/AmountLabel



func _ready() -> void:
	tooltip_timer.timeout.connect(_request_tooltip)
	mouse_entered.connect(tooltip_timer.start)
	mouse_exited.connect(tooltip_timer.stop)


func display_item(unique_id: String, amount: int) -> void:
	item_unique_id = unique_id

	var data := ItemDatabase.get_item_data(unique_id)
	texture_rect.texture = data.icon
	name_label.text = data.display_name
	amount_label.text = str(amount).pad_zeros(2)


func _request_tooltip() -> void:
	if item_unique_id:
		tooltip_requested.emit()
