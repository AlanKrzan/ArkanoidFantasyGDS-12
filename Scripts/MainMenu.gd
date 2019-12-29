extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded
func _ready():
    Global.score=0
    Global.life=3


func _on_Exit_pressed():
    get_tree().quit()

#warning-ignore:unused_argument
func _process(delta):
    if Input.is_action_just_released("ui_select"): 
        _on_PlayButton_pressed()
    if Input.is_action_just_pressed("ui_cancel"):
        _on_Exit_pressed()

func _on_PlayButton_pressed():
    get_tree().change_scene("res://Level1.tscn")




func _on_HighscoreButton_pressed():
    get_tree().change_scene("res://HighScores.tscn")
