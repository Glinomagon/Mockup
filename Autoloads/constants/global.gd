extends Node

# Player related
enum BODY_PART { BODY, EYES, PUPILS, HAIR }
enum CHARACTER_DIRECTION { FRONT, SIDE, BACK }

const PLAYER_MOVE_SPEED: float = 20.0

const PLAYER_TEXTURES: Dictionary = {
  BODY_PART.BODY: "res://Assets/Sprites/BaseSprite/base_sprite-walking.png",
  BODY_PART.EYES: "res://Assets/Sprites/BaseSprite/base_sprite-_eyes-walking.png",
  BODY_PART.PUPILS: "res://Assets/Sprites/BaseSprite/base_sprite_pupils-walking.png",
  BODY_PART.HAIR: "res://Assets/Sprites/BaseSprite/base_hair.png",
}

const PLAYER_FOOTSTEPS: Dictionary[String, Array] = {
  "grass_walk": [
    "res://Assets/SFX/Footsteps_Walk_Grass_Mono_50.wav",
    "res://Assets/SFX/Footsteps_Walk_Grass_Mono_49.wav",
    "res://Assets/SFX/Footsteps_Walk_Grass_Mono_48.wav",
    "res://Assets/SFX/Footsteps_Walk_Grass_Mono_47.wav",
    "res://Assets/SFX/Footsteps_Walk_Grass_Mono_46.wav"
  ],
  "dirt_walk": [
    "res://Assets/SFX/Footsteps_DirtyGround_Walk_04.wav",
    "res://Assets/SFX/Footsteps_DirtyGround_Walk_05.wav",
    "res://Assets/SFX/Footsteps_DirtyGround_Walk_06.wav",
    "res://Assets/SFX/Footsteps_DirtyGround_Walk_09.wav"
  ],
}

func get_player_footsteps(sound_library: String) -> Array[String]:
  match sound_library:
    "grass_walk":
      return [
        "res://Assets/SFX/Footsteps_Walk_Grass_Mono_50.wav",
        "res://Assets/SFX/Footsteps_Walk_Grass_Mono_49.wav",
        "res://Assets/SFX/Footsteps_Walk_Grass_Mono_48.wav",
        "res://Assets/SFX/Footsteps_Walk_Grass_Mono_47.wav",
        "res://Assets/SFX/Footsteps_Walk_Grass_Mono_46.wav"
      ]
    "dirt_walk":
      return [
        "res://Assets/SFX/Footsteps_DirtyGround_Walk_04.wav",
        "res://Assets/SFX/Footsteps_DirtyGround_Walk_05.wav",
        "res://Assets/SFX/Footsteps_DirtyGround_Walk_06.wav",
        "res://Assets/SFX/Footsteps_DirtyGround_Walk_09.wav"
      ]
    _:
      return []

# Custom player related
const CLOTHES_TOP_PATH: Array = [
  "res://Assets/Sprites/Clothes/base-shirt_01.png",
  "res://Assets/Sprites/Clothes/base-shirt_02.png",
  "res://Assets/Sprites/Clothes/base-shirt_03.png"
]

const CLOTHES_BOTTOMS_PATH: Array = [
  "res://Assets/Sprites/Clothes/base-pants_01.png",
  "res://Assets/Sprites/Clothes/base-pants_02.png"
]

const SKIN_COLOURS: Array = [
  "#6a4424",
  "#8d5524",
  "#c68642",
  "#e0ac69",
  "#f1c27d",
  "#ffdbac",
  "#ffecac",
]

const EYE_COLOURS: Array = [
  "#3c1804",
  "#9a7238",
  "#40ab61",
  "#369991",
  "#49addf",
  "#989696",
]

const HAIR_COLOURS: Array = [
  "#241c11",
  "#362a20",
  "#5c4028",
  "#4f1a00",
  "#9a3300",
  "#c6a969",
  "#fbe7a1",
  "#fdee87",
  "#9b30ff",
  "#8d9092",
  "#c30101",
  "#138510",
  "#095f92"
]

const CLOTHING_COLOURS: Array = [
  "#ffffff",
  "#c30101",
  "#138510",
  "#095f92",
  "#9b30ff",
  "#ffff00",
  "#241c11",
  "#989696",
  "#9a7238",
]

# Clothing related
enum CLOTHING_TYPE { TOP, BOTTOM }