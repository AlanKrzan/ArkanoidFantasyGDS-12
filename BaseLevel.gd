extends Node2D


var Ball = preload("res://Ball.tscn")   #wczytywanie schematu piłki
var Block = preload("res://Block.tscn") #wczytywanie schematu bloczka
var Enemy = preload("res://BaseEnemy.tscn")
var Basic = preload("res://BasePowerUp.tscn")
var score=0                             #inicjalizacja wyniki
var started=false                       #czy rozgrywka się zaczeła?, używana w logice gry
var life=3                              #inicjalizacja ilości żyć
var blocks_left=0                       #licznik bloczków
var spawn_trigger_value
var spawn_permission=true
export var upgrade_count=5
export var basic_powerup_count=5
signal stop
signal move

#funkcja rozpoczęcia rozgrywki
func new_game():
    started=true
    var c = Ball.instance()
    c.start(($Paddle.position+Vector2(0,-30)))
    $Paddle/BallDummy.hide()
    self.connect("stop",c,"stop_movement")
    get_parent().add_child(c)
    emit_signal("move")
    $Hud.hide_message()

#ustawienie elementów gry do rozgrywki
func _ready():
    randomize()
    $Paddle.start($StartPosition.position)
    var blocks = get_tree().get_nodes_in_group("Block")
    blocks_left = blocks.size()
    spawn_trigger_value = blocks_left*0.75
    for block in blocks:
        block.set_level(1)
        block.connect("points",self,"_get_points")
    var sample=__rand_sample(upgrade_count,blocks)
    var powerup_list=_powerup_list()
    
    for i in range(sample.size()):
        sample[i].set_power(powerup_list[i])
    $Hud.show_message("Press SPACE to start")

func _powerup_list():
    var list=[]
    for i in range(basic_powerup_count):
        list.append(Basic)
    return list

func _spawn_enemy():
    if spawn_permission and spawn_trigger_value > blocks_left:
        spawn_permission=false
        var e = Enemy.instance()
        e.start(($Top/SpawnPosition.get_global_transform_with_canvas().get_origin()))
        self.connect("stop",e,"stop_movement")
        self.connect("move",e,"restart_movement")
        e.connect("points",self,"_get_points")
        get_parent().add_child(e)

#funkcja przyznanie punktów, sprawdzenie warunku zwycięstwa
func _get_points(points,is_block):
    score+=points
    $Hud.update_score(score)
    if is_block:
        blocks_left -= 1
        print(get_tree().get_nodes_in_group("Block").size())
        if blocks_left <= 0:
            _win()
            started=false
            return
    _spawn_enemy()
    
#funckja zwycięstwa?
func _win():
    emit_signal("stop")
    $Hud.show_message("Victory")
    
#funkcja przegrania gry
func _game_over():
    $Hud.show_message("GAME OVER")

#wbudowan funkcja, nadpisana aby sprawdzić czy spacja jest wciśnieta do rozpoczęcia rozgrywki
func _process(delta):
    if Input.is_action_pressed("ui_select") and !started:
        new_game()
                
#funkcja ucieczki piłki, sprawdzanie warunku porażki
func _on_Bottom_redo():
    life-=1
    $Hud.update_life(life)
    if life>0:
        emit_signal("stop")
        $Paddle.reset()
        $Paddle/BallDummy.show()
        $Hud.show_message("Press SPACE to start")
        $Paddle.start($StartPosition.position)
        started=false
    else:
        _game_over()
#funkcja zwracająca próbkę n elementów z listy
func __rand_sample(n,list):
    var sample = []
    for i in range(n):
        var x = randi()%list.size()
        sample.append(list[x])
        list.remove(x)
    return sample

