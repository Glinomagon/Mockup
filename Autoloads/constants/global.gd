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