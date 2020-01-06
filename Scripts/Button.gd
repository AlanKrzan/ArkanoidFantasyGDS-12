extends Button

var where_to

func start(string, path):
    text = string
    where_to = path

func _ready():
    text="Setup this text you dummy"
    $Sprite.hide()

func _on_PlayButton_focus_entered():
    $Sprite.show()


func _on_PlayButton_focus_exited():
    $Sprite.hide()
