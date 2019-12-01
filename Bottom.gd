extends Area2D

signal redo

func _on_Bottom_body_entered(body):
    if body.is_in_group("Ball"):
        emit_signal("redo")
    if body.has_method("die"):
        body.die()

func _on_Bottom_area_entered(area):
    area.queue_free()
