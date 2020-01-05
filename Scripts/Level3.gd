extends "res://Scripts/BaseLevel.gd"
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded

#funkcje importowane z BaseLevel.gd: new_game, _spawn_ball, _add_life, _powerup_list, _spawn_check, _spawn_enemy,
# _leaving, _process, _extra_balls, _enable_enemy, __rand_sample, _on_SpeedUpTimer_timeout, _on_EscapeTimer_timeout,
# _on_AnimatedSprite_animation_finished

#ustawienie elementów gry do rozgrywki
func _ready():
    randomize()
    Hud_signals()
    populate_map("res://data/level3.json")
    $Hud.update_score(Global.score)
    if Global.check_if_score_higher():
        $Hud.update_highscore(0)
    else:
        $Hud.update_highscore(Global.highscore)
    #upgrade_count = extend_powerup_count + sticky_count + extra_life_count + win_powerup_count \
    #+ fire_powerup_count + extra_balls_powerup_count + slow_powerup_count
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
    #var powerup_list=_powerup_list()
    #for i in range(sample.size()):
    #    sample[i].set_power(powerup_list[i])
    $Hud.show_message("Press SPACE to start")
    $NewGameSound.play()


#funkcja przyznanie punktów, sprawdzenie warunku zwycięstwa
func _get_points(points,is_block):
    Global.score+=points
    $Hud.update_score(Global.score)
    if Global.check_if_score_higher() and not Global.newBest:
        Global.set_bestscore(Global.score)
        $Hud.update_highscore(0)
        $Hud.show_message("New record")
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
    emit_signal("leaving_stop")
    menu=false
    $Hud.show_message("Victory")
    $WinTimer.start()


func _on_WinTimer_timeout():
    emit_signal("purge")
    get_tree().change_scene("res://MainMenu.tscn")
