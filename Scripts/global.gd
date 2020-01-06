extends Node
#warning-ignore-all:unused_variable

var score=-1
var life=3
var Ball = preload("res://Ball.tscn")   #wczytywanie schematu piłki
var Enemy = preload("res://BaseEnemy.tscn")
#var Extend = preload("res://ExtendPowerUp.tscn")
#var Fire = preload("res://FirePowerUp.tscn")
#var Extra = preload("res://ExtraLifePowerUp.tscn")
#var Balls = preload("res://ExtraBallPowerUp.tscn")
#var Sticky = preload("res://StickyPowerUp.tscn")
#var Win = preload("res://WinPowerUp.tscn")
#var Slow = preload("res://SlowPowerUp.tscn")
var upgrades={
    "Lasers":preload("res://FirePowerUp.tscn"),
    "Catch":preload("res://StickyPowerUp.tscn"),
    "Slow":preload("res://SlowPowerUp.tscn"),
    "Bye":preload("res://WinPowerUp.tscn"),
    "Extra-Life":preload("res://ExtraLifePowerUp.tscn"),
    "Expand":preload("res://ExtendPowerUp.tscn"),
    "Duplicate":preload("res://ExtraBallPowerUp.tscn")
   }
var Blocks={
    "blue": preload("res://BlueBlock.tscn"), #1
    "cyan": preload("res://CyanBlock.tscn"), #2
    "gold": preload("res://GoldenBlock.tscn"), #3
    "green": preload("res://GreenBlock.tscn"), #4
    "orange": preload("res://OrangeBlock.tscn"), #5
    "pink": preload("res://PinkBlock.tscn"), #6
    "red": preload("res://RedBlock.tscn"),  #7
    "silver": preload("res://SilverBlock.tscn"), #8
    "white": preload("res://WhiteBlock.tscn"), #9
    "yellow": preload("res://YellowBlock.tscn") #10
}
const scorepath = "user://highscore.data"
const highscorepath = "user://highscores.data"
var highscore = 10000
var newBest = false
var scores = [
    {"score":30000,"name":"alice"}, #1
    {"score":25000,"name":"bob"}, #2
    {"score":20000,"name":"stan"},#3
    {"score":15000,"name":"joe"}, #4
    {"score":10000,"name":"nowak"}, #5
    {"score":9000,"name":"alice"}, #6
    {"score":8000,"name":"anna"}, #7
    {"score":7000,"name":"steve"}, #8
    {"score":6000,"name":"mark"}, #9
    {"score":5000,"name":"mercedes"} #10
]

func load_highscores():
    var file = File.new()
    if not file.file_exists(highscorepath): return
    file.open(highscorepath, File.READ)
    scores = parse_json(file.get_as_text())
    file.close()

func scoreComparison(a,b):
    return a["score"] > b["score"]
    
func checkScore():
    for i in range(10):
        if score>scores[i]['score']:
            return true
    return false

func insertScore(name):
    for i in range(10):
        if score>scores[i]['score']:
            scores.insert(i,{"score":score,"name":name})
            save_highscores()
            return i
    return 10

func save_highscores():
    var file = File.new()
    file.open(highscorepath, File.WRITE)
    scores.sort_custom(self,"scoreCamparison")
    var tmp=[]
    for i in range(10):
        tmp.append(scores[i])
    scores=tmp
    file.store_string(to_json(tmp))
    file.close()
    highscore = scores[0]['score']
    newBest=false
    pass


func check_if_score_higher():
    if score>scores[0]['score']:
        return true
    else:
        return false 

func set_bestscore(new_value):
    newBest = true
    highscore = new_value
    
func _ready():
    load_highscores()
    highscore = scores[0]['score']
