extends MarginContainer

@onready var label: Label = %Label
@onready var level_state := Globals.get_level().level_state
@onready var player_state := Globals.get_player().state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	label.text = "Level Runes Collected: %s/%s\nTotal Runes Collected: %s" % [level_state.collected_runes,level_state.total_level_runes, player_state.rune_number]
