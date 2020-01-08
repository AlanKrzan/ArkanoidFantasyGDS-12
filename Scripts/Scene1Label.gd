extends Label

func _ready():
    set_visible_characters(0)
    set_process_input(true)

func _input(event):
    if Input.is_action_just_released("ui_select"):
        print(get_visible_characters()," ",get_total_character_count())
        if get_visible_characters() >= get_total_character_count():
            get_tree().change_scene("res://Scene2.tscn")
        else:
            set_visible_characters(get_total_character_count())
    if Input.is_action_just_released("ui_cancel"):
        get_tree().change_scene("res://Level1.tscn")

func _on_Timer_timeout():
    set_visible_characters(get_visible_characters()+1)
    
    