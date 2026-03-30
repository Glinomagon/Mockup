extends Node

var entity_streams : Dictionary = {}

func create_new_entity_stream(entity_name : String, stream_name : String, stream_type : String, audio_paths : Array[String]) -> void:
	if stream_type == "random":
		var new_random_stream : AudioStreamRandomizer = AudioStreamRandomizer.new()
		for i in range(audio_paths.size()):
			new_random_stream.add_stream(i, load(audio_paths[i]))

		new_random_stream.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM_NO_REPEATS
		entity_streams.get_or_add(entity_name, {})[stream_name] = AudioStreamPlayer.new()

		entity_streams[entity_name][stream_name].bus = "SFX"
		entity_streams[entity_name][stream_name].stream = new_random_stream

		add_child(entity_streams[entity_name][stream_name])

func play_entity_stream(entity_name : String, stream_name : String) -> void:
	if entity_streams[entity_name][stream_name].playing:
		entity_streams[entity_name][stream_name].stop()
	entity_streams[entity_name][stream_name].play()
