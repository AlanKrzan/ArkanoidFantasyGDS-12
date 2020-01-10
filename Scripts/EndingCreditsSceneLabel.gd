extends RichTextLabel

func _ready():
    set_visible_characters(0)
    set_process_input(true)

func _input(event):
    if Input.is_action_just_released("ui_select"):
        if get_visible_characters() >= get_total_character_count():
            get_tree().change_scene("res://MainMenu.tscn")
        else:
            set_visible_characters(get_total_character_count())
    if Input.is_action_just_released("ui_cancel"):
        get_tree().change_scene("res://MainMenu.tscn")

func _on_Timer_timeout():
    set_visible_characters(get_visible_characters()+1)
    
    