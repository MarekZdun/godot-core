extends Control

@onready var actor_position_label := $MarginContainer/VBoxContainer/ActorPositionLabel
@onready var run_speed_slider := $MarginContainer/VBoxContainer/HBoxContainer/RunSpeedSlider
@onready var strength_spinbox := $MarginContainer/VBoxContainer/HBoxContainer2/StrengthSpinbox
@onready var endurance_spinbox := $MarginContainer/VBoxContainer/HBoxContainer3/EnduranceSpinbox
@onready var intelligence_spinbox := $MarginContainer/VBoxContainer/HBoxContainer4/IntelligenceSpinbox
@onready var health_label := $MarginContainer/VBoxContainer/HBoxContainer5/HealthLabel
@onready var reward_label := $MarginContainer/VBoxContainer/HBoxContainer6/RewardLabel

var actor_stats: Resource: set = set_actor_stats
var _ignore_value_change := false


func _ready():
	run_speed_slider.connect("value_changed", Callable(self, "_on_value_changed"))
	strength_spinbox.connect("value_changed", Callable(self, "_on_value_changed"))
	endurance_spinbox.connect("value_changed", Callable(self, "_on_value_changed"))
	intelligence_spinbox.connect("value_changed", Callable(self, "_on_value_changed"))
	
	
func set_actor_stats(new_actor_stats: Resource) -> void:
	if actor_stats != new_actor_stats:
		new_actor_stats.connect("health_changed", Callable(self, "update_health_label"))
		new_actor_stats.connect("runtime_collected", Callable(self, "update_reward_label"))
		if new_actor_stats.has_signal("global_position_changed"):
			new_actor_stats.connect("global_position_changed", Callable(self, "update_player_position"))
		
	actor_stats = new_actor_stats
	# Changing the spin box value triggers their value_changed signal, which we
	# use to update the character stats using the panel.
	# This boolean prevents changing the spinbox values from code from
	# overwriting the character resource.
	_ignore_value_change = true
	
	run_speed_slider.value = actor_stats.run_speed
	strength_spinbox.value = actor_stats.strength
	endurance_spinbox.value = actor_stats.endurance
	intelligence_spinbox.value = actor_stats.intelligence
	update_health_label(actor_stats.health)
	update_reward_label(actor_stats.reward_runtime_collected)
	
	_ignore_value_change = false
	
	
func update_player_position(global_position: Vector2) -> void:
	actor_position_label.text = "Global position: " + str(global_position.round())
	
	
func update_health_label(health: int) -> void:
	health_label.text = str(health)
	
	
func update_reward_label(reward: int) -> void:
	reward_label.text = str(reward)
	
	
func _on_value_changed(new_value: float) -> void:
	if _ignore_value_change:
		return
		
	actor_stats.run_speed = run_speed_slider.value
	actor_stats.strength = strength_spinbox.value
	actor_stats.endurance = endurance_spinbox.value
	actor_stats.intelligence = intelligence_spinbox.value
