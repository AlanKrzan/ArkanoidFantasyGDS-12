extends KinematicBody2D

export var score=50
var level=0
var lives=4
signal points(score,is_ball) #deklaracji sygnalu do przekazywania punktów
var power_up=null
signal win

func _ready():
    $Sprite5.show()

#funkcja zwracająca wynik i niszcząca bloczek
func death():
    queue_free()
    
func start(pos):
    position=pos

func hit():
    if lives>0:
        lives-=1
        match lives:
            3:
                $Sprite4.show()
                $Sprite5.hide()
            2:
                $Sprite4.hide()
                $Sprite3.show()
            1:
                $Sprite3.hide()
                $Sprite2.show()
            0:
                $Sprite.show()
                $Sprite2.hide()
            
    else:
        emit_signal("points",_get_score(),true)
        emit_signal("win")
        queue_free()
    
func set_power(powerup):
    power_up=powerup
    
func set_level(current_level):
    level=current_level
    
func _get_score(): # wstępna deklaracja funkcji obliczającej ilość punktów
    return score*level