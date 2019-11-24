extends Node2D


var Ball = preload("res://Ball.tscn")   #wczytywanie schematu piłki
var Block = preload("res://Block.tscn") #wczytywanie schematu bloczka
var score=0                             #inicjalizacja wyniki
var started=false                       #czy rozgrywka się zaczeła?, używana w logice gry
var life=3                              #inicjalizacja ilości żyć
var blocks_left=0                       #licznik bloczków
signal stop
#ustawienie elementów gry do rozgrywki
func _ready():
    $Paddle.start($StartPosition.position)
    var blocks = get_tree().get_nodes_in_group("Block")
    blocks_left = blocks.size()
    for block in blocks:
        block.connect("points",self,"_get_points")
    $Hud.show_message("Press SPACE to start")



#funkcja przyznanie punktów, sprawdzenie warunku zwycięstwa
func _get_points(points):
    score+=points
    $Hud.update_score(score)
    blocks_left-=1
    print(get_tree().get_nodes_in_group("Block").size())
    if blocks_left<=0:
        _win()
        started=false

#funckja zwycięstwa?
func _win():
    emit_signal("stop")
    $Hud.show_message("Victory")
    

    
#funkcja przegrania gry
func _game_over():
    $Hud.show_message("GAME OVER")

#funkcja rozpoczęcia rozgrywki
func new_game():
    started=true
    var c = Ball.instance()
    c.start(($Paddle.position+Vector2(0,-30)))
    $Paddle/BallDummy.hide()
    self.connect("stop",c,"stop_movement")
    get_parent().add_child(c)
    $Hud.hide_message()

#wbudowan funkcja, nadpisana aby sprawdzić czy spacja jest wciśnieta do rozpoczęcia rozgrywki
func _process(delta):
    if Input.is_action_pressed("ui_select") and !started:
        new_game()
        
        
#funkcja ucieczki piłki, sprawdzanie warunku porażki
func _on_Bottom_redo():
    life-=1
    $Hud.update_life(life)
    if life>0:
        $Paddle/BallDummy.show()
        $Hud.show_message("Press SPACE to start")
        $Paddle.start($StartPosition.position)
        started=false
    else:
        _game_over()

