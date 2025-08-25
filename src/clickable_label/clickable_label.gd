extends RichTextLabel

func _ready() -> void:
	if OS.get_name() == "Web":
		return
	meta_clicked.connect(_on_meta_clicked)

func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
