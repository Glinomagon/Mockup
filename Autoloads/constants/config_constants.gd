extends Node

enum CONFIG_SECTION {
	WINDOW,
}

const STRING_TO_CONFIG_SECTION = {
	WINDOW: CONFIG_SECTION.WINDOW,
}

const CONFIG_SECTION_TO_STRING = {
	CONFIG_SECTION.WINDOW: WINDOW,
}

# constants to avoid mispellings
const RESOLUTION = "Resolution"
const WINDOW = "Window"
const FULLSCREEN = "Fullscreen"
const WINDOW_MODE = "Window Mode"
const BORDERLESS_MODE = "Borderless Mode"
