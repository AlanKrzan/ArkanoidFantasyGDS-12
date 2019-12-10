extends Area2D

signal redo

# funckja obsługi obiektów dotykających 
func _on_Bottom_body_entered(body):
    if body.is_in_group("Ball"):
        emit_signal("redo")
    if body.has_method("die"):
        body.die()

# funkcja osuwająca obaszary 
func _on_Bottom_area_entered(area):
    if not area.is_in_group("Level"):
        area.queue_free()
