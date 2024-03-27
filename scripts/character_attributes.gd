extends Node

enum CharacterType {NONE, PLAYER, RAT}

@export var character_type : CharacterType = CharacterType.NONE
@export var health : int = 1
@export var damage : int = 0
@export var speed : float = 1
@export var drop_experience : int = 1
