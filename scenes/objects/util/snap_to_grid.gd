## helper component that helps snaping the parent to a grid when placing in the editor
@tool
class_name SnapToGrid extends Node

@export var grid_size := Vector2(16,16)
@export_range(-360,360,1,"suffix:°") var rotation_degree_amount := 45

var parent : Node

func _ready() -> void:
	# delete this node if not in the editor since it's not needed
	if !Engine.is_editor_hint():
		queue_free()
		
	parent = get_parent()

func _process(_delta: float) -> void:
	# redraw the parent every frame so it updates correctly when editing
	redraw_parent()
		
func redraw_parent() -> void:
	
	# the parent node could be a Node2D or Control node so we just check if it has the values before actually setting them
	
	if "position" in parent:
		parent["position"] = snapped(parent["position"], grid_size)

	if "rotation_degrees" in parent:
		parent["rotation_degrees"] = snapped(parent["rotation_degrees"], rotation_degree_amount)

	if "size" in parent:
		parent["size"] = snapped(parent["size"], grid_size)
