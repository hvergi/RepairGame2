extends Camera2D

func _ready() -> void:
	get_tree().root.size_changed.connect(on_viewport_size_changed)
	update_scale()
	
	
func update_scale() -> void:
	var size = get_tree().root.get_visible_rect().size
	zoom = Vector2(size.x/1280,size.y/720)
	
func on_viewport_size_changed() -> void:
	update_scale()
