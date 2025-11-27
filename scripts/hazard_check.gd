extends Node

@onready var tile_map_layer: TileMapLayer = get_tree().get_first_node_in_group("InteractableTileMapLayer")

var _parent : CharacterBody2D
var _last_hazard_check: float = 0.0
var _hazard_check_rate: float = 0.1  # Check 10 times per second

func _ready() -> void:
	_parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	_last_hazard_check += delta
	if _last_hazard_check >= _hazard_check_rate:
		_check_for_hazard()

func _check_for_hazard() -> void:
	var map_pos := tile_map_layer.local_to_map(_parent.global_position)
	
	# get the TileData for the cell at that position
	var center_tile_data := tile_map_layer.get_cell_tile_data(map_pos)
	
	if _has_hazard(center_tile_data):
		_kill()
		return
	
	var down_tile_data := tile_map_layer.get_cell_tile_data(Vector2(map_pos.x , map_pos.y + 1))
	
	# check edge case where the playe can land on a diagonal tile with hazards surrounding it
	if _has_hazard(down_tile_data):
		var right_tile_data := tile_map_layer.get_cell_tile_data(Vector2(map_pos.x + 1, map_pos.y))
		var left_tile_data := tile_map_layer.get_cell_tile_data(Vector2(map_pos.x - 1, map_pos.y))
		if _has_hazard(left_tile_data) || _has_hazard(right_tile_data):
			_kill()
	
func _has_hazard(tile_data: TileData) -> bool:
	# check if the tile exists and has the custom data
	return tile_data && tile_data.get_custom_data("is_hazard")
	
func _kill() -> void:
	if _parent is Player:
		Events.player_died.emit()
	elif _parent is IAEnemy:
		(_parent as IAEnemy).die()
