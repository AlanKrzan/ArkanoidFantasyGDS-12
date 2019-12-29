extends Node2D


func _ready():
    for i in range(10):
        var text =str(Global.scores[i]['score'])+" "
        while len(text)<8:
            text+=' '
        $ItemList.add_item(text+Global.scores[i]['name'],null,false)


func _on_Button_pressed():
    get_tree().change_scene("res://MainMenu.tscn")
    
