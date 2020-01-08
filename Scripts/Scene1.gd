extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    $ColorRect2/Label.set_visible_characters(0)
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Timer_timeout():
    $ColorRect2/Label.set_visible_characters($ColorRect2/Label.get_visible_characters()+1)
