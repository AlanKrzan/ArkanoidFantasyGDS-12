extends Node
#warning-ignore-all:unused_variable

var score=-1
var life=1
var Ball = preload("res://Ball.tscn")   #wczytywanie schematu piłki
var Enemy = preload("res://BaseEnemy.tscn")
var Extend = preload("res://ExtendPowerUp.tscn")
var Fire = preload("res://FirePowerUp.tscn")
var Extra = preload("res://ExtraLifePowerUp.tscn")
var Balls = preload("res://ExtraBallPowerUp.tscn")
var Sticky = preload("res://StickyPowerUp.tscn")
var Win = preload("res://WinPowerUp.tscn")
var Slow = preload("res://SlowPowerUp.tscn")
var upgrades=[]
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

func _ready():
    life=3
    score=0
    upgrades.append(Enemy)
    upgrades.append(Extend)
    upgrades.append(Fire)
    upgrades.append(Extra)
    upgrades.append(Balls)
    upgrades.append(Sticky)
    upgrades.append(Win)
    upgrades.append(Slow)
