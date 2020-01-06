extends StaticBody2D

func start(pos):
    position=pos
    var x=randf()
    if x>0.66:
        $Sprite.show()
    elif x>0.33:
        $Sprite2.show()
    else:
        $Sprite3.show()
