extends Node

# Player related
enum BODY_PART { BODY, EYES, PUPILS, HAIR }
enum CHARACTER_DIRECTION { FRONT, SIDE, BACK }

var PlayerTextures: Dictionary = {
  BODY_PART.BODY: {
    CHARACTER_DIRECTION.FRONT: "res://Assets/Sprites/BaseSprite/base_sprite-walking.png"
  },
  BODY_PART.EYES: "res://Assets/Sprites/BaseSprite/base_sprite-_eyes-walking.png",
  BODY_PART.PUPILS: "res://Assets/Sprites/BaseSprite/base_sprite_pupils-walking.png",
  BODY_PART.HAIR: "res://Assets/Sprites/BaseSprite/base_hair.png",
}

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