extends Node2D


func _ready():
    pass # Replace with function body.


func _on_Exit_pressed():
    get_tree().quit()


func _on_PlayButton_pressed():
    get_tree().change_scene("res://Level1.tscn")
