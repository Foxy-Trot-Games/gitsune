@tool
class_name TutorialOverlay extends OverlaidMenu

@onready var title_label: Label = %TitleLabel
@onready var description_label: RichTextLabel = %DescriptionLabel

var tutorial_resource : TutorialResource

func _ready() -> void:
	title_label.text = tutorial_resource.title
	description_label.text = tutorial_resource.description_template
