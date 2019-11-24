extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal redo
# Called when the node enters the scene tree for the first time.
func _ready():
    pass
func hit():
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Bottom_body_entered(body):
    emit_signal("redo")
    if body.has_method("die"):
        body.die()
