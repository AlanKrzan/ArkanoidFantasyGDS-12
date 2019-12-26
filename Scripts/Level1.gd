extends "res://Scripts/BaseLevel.gd"
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded

#funkcje importowane z BaseLevel.gd: new_game, _spawn_ball, _add_life, _powerup_list, _spawn_check, _spawn_enemy,
# _leaving, _process, _extra_balls, _enable_enemy, __rand_sample, _on_SpeedUpTimer_timeout, _on_EscapeTimer_timeout,
# _on_AnimatedSprite_animation_finished, 

#ustawienie elementów gry do rozgrywki
func _ready():
    randomize()
    populate_map("res://data/level1.json")
    Global.score=0
    Global.life=3
    $Hud.update_score(Global.score)
    upgrade_count = extend_powerup_count + sticky_count + extra_life_count + win_powerup_count \
    + fire_powerup_count + extra_balls_powerup_count + slow_powerup_count
    $Paddle.start($StartPosition.position)
    var blocks = get_tree().get_nodes_in_group("Block")
    blocks_left = blocks.size()
    spawn_trigger_value = blocks_left*0.75
    self.connect("stop",$Paddle,"_stop_movement")
    self.connect("move",$Paddle,"_start_movement")
    for block in blocks:
        if block.has_method("set_level"):
            block.set_level(level)
        block.connect("points",self,"_get_points")
        self.connect("purge",block,"death")
    var sample
    if upgrade_count < blocks.size():
        #print(upgrade_count," ",blocks.size())
        sample=__rand_sample(upgrade_count,blocks)
    else:
        sample=__rand_sample(blocks.size(),blocks)
    var powerup_list=_powerup_list()
    for i in range(sample.size()):
        sample[i].set_power(powerup_list[i])
    $Hud.show_message("Press SPACE to start")

#funkcja przyznanie punktów, sprawdzenie warunku zwycięstwa
#nie przeniesiona nad ponieważ wymaga funkcji zwyciestwa
func _get_points(points,is_block):
    Global.score+=points
    $Hud.update_score(Global.score)
    if is_block:
        blocks_left -= 1
        if blocks_left==1:
            var blocks = get_tree().get_nodes_in_group("Block")
            for block in blocks:
                block.set_power(null)
        if blocks_left <= 0:
            _win()
            started=false
            return
    if _spawn_check():
        $Top/AnimatedSprite.play("")


#funckja zwycięstwa TODO zmienić scenę na następny poziom, jak już będzie
func _win():
    emit_signal("stop")
    $Hud.show_message("Victory")
    $WinTimer.start()

#funkcja przegrania gry, powrót do menu po czasie
func _game_over():
    emit_signal("stop")
    Global.score=0
    $Hud.show_message("GAME OVER")
    $EscapeTimer.start()



#funkcja ucieczki piłki, sprawdzanie warunku porażki
func _on_Bottom_redo():
    if extra_balls>0:
        extra_balls-=1
    else:
        life-=1
        $Hud.update_life(life)
        if life>0:
            emit_signal("stop")
            emit_signal("die")
            $Paddle.reset()
            $Paddle/BallDummy.show()
            $Hud.show_message("Press SPACE to start")
            $Paddle.start($StartPosition.position)
            started=false
        else:
            _game_over()

func _on_WinTimer_timeout():
    emit_signal("purge")
    get_tree().change_scene("res://Level2.tscn")
