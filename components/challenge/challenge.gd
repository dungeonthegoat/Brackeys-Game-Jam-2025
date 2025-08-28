@icon("res://components/challenge/challenge.svg")
class_name Challenge
extends Resource


enum Difficulty {
    VERY_EASY,
    EASY,
    MEDIUM,
    DIFFICULT,
    EXTREME
}


var name: StringName
var difficulty: Difficulty
var reward: Dictionary
var scene_path: String