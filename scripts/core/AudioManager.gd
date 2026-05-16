extends Node
## AudioManager Autoload
## Centralized audio management for SFX and music

# Signals
signal music_changed(track_name: String)
signal sfx_played(sfx_name: String)
signal volume_changed(bus: String, volume: float)

# Audio buses (must match project.godot)
const MASTER_BUS := "Master"
const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"
const UI_BUS := "UI"

# State
var current_music_track: String = ""
var is_music_playing: bool = false
var is_muted: bool = false

# Music crossfade
var music_crossfade_duration: float = 1.0
var music_crossfade_timer: float = 0.0
var music_crossfading: bool = false

# Audio players
var music_players: Dictionary = {}  # { track_name: AudioStreamPlayer }
var sfx_pool: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE: int = 8

# Volume settings (in dB, linear 0.0-1.0 converted)
var master_volume: float = 0.0
var music_volume: float = 0.0
var sfx_volume: float = 0.0
var ui_volume: float = 0.0


func _ready() -> void:
	_initialize_sfx_pool()
	_load_default_volumes()


func _initialize_sfx_pool() -> void:
	for i in range(SFX_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		sfx_pool.append(player)


func _load_default_volumes() -> void:
	# Load from settings or use defaults
	master_volume = _get_setting("audio/master_volume", 0.0)
	music_volume = _get_setting("audio/music_volume", 0.8)
	sfx_volume = _get_setting("audio/sfx_volume", 0.85)
	ui_volume = _get_setting("audio/ui_volume", 0.8)
	
	_apply_volumes()


func _get_setting(key: String, default: float) -> float:
	if ProjectSettings.has_setting(key):
		return ProjectSettings.get_setting(key)
	return default


func _process(delta: float) -> void:
	if music_crossfading:
		music_crossfade_timer += delta
		if music_crossfade_timer >= music_crossfade_duration:
			music_crossfading = false


## Play a sound effect
func play_sfx(sfx_name: String, stream: AudioStream, pitch_variance: float = 0.0) -> void:
	var player := _get_available_sfx_player()
	if player == null:
		push_warning("SFX pool exhausted, skipping: " + sfx_name)
		return
	
	player.stream = stream
	player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
	player.play()
	
	sfx_played.emit(sfx_name)


## Play SFX from resource path
func play_sfx_from_path(sfx_name: String, path: String, pitch_variance: float = 0.0) -> void:
	var stream := load(path) as AudioStream
	if stream == null:
		push_error("Failed to load SFX: " + path)
		return
	
	play_sfx(sfx_name, stream, pitch_variance)


## Get available SFX player from pool
func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_pool:
		if not player.playing:
			return player
	# If all busy, return first one (will interrupt)
	return sfx_pool[0] if sfx_pool.size() > 0 else null


## Play music track
func play_music(track_name: String, stream: AudioStream, fade_in: bool = true) -> void:
	if current_music_track == track_name and is_music_playing:
		return  # Already playing
	
	# Stop current music
	if is_music_playing:
		stop_music(fade_in)
	
	# Create or get music player
	var player := _get_music_player(track_name)
	player.stream = stream
	player.bus = MUSIC_BUS
	
	if fade_in:
		player.volume_db = -80.0  # Start silent
		player.play()
		_crossfade_in(player)
	else:
		player.play()
	
	current_music_track = track_name
	is_music_playing = true
	music_changed.emit(track_name)


## Play music from resource path
func play_music_from_path(track_name: String, path: String, fade_in: bool = true) -> void:
	var stream := load(path) as AudioStream
	if stream == null:
		push_error("Failed to load music: " + path)
		return
	
	play_music(track_name, stream, fade_in)


## Get or create music player for track
func _get_music_player(track_name: String) -> AudioStreamPlayer:
	if music_players.has(track_name):
		return music_players[track_name]
	
	var player := AudioStreamPlayer.new()
	player.bus = MUSIC_BUS
	add_child(player)
	music_players[track_name] = player
	return player


## Stop current music
func stop_music(fade_out: bool = true) -> void:
	if not is_music_playing:
		return
	
	if fade_out:
		_crossfade_out()
	else:
		for player in music_players.values():
			if player.playing:
				player.stop()
	
	is_music_playing = false
	current_music_track = ""


## Crossfade in new music
func _crossfade_in(player: AudioStreamPlayer) -> void:
	music_crossfading = true
	music_crossfade_timer = 0.0
	
	var tween := create_tween()
	tween.tween_property(player, "volume_db", music_volume, music_crossfade_duration)


## Crossfade out current music
func _crossfade_out() -> void:
	music_crossfading = true
	music_crossfade_timer = 0.0
	
	for player in music_players.values():
		if player.playing:
			var tween := create_tween()
			tween.tween_property(player, "volume_db", -80.0, music_crossfade_duration)
			await tween.finished
			player.stop()


## Pause all audio
func pause_all() -> void:
	AudioServer.set_bus_mute(get_bus_index(MASTER_BUS), true)


## Resume all audio
func resume_all() -> void:
	AudioServer.set_bus_mute(get_bus_index(MASTER_BUS), false)


## Set master volume (linear 0.0-1.0)
func set_master_volume(linear_value: float) -> void:
	master_volume = clamp(linear_value, 0.0, 1.0)
	ProjectSettings.set_setting("audio/master_volume", master_volume)
	_apply_volumes()
	volume_changed.emit(MASTER_BUS, master_volume)


## Set music volume (linear 0.0-1.0)
func set_music_volume(linear_value: float) -> void:
	music_volume = clamp(linear_value, 0.0, 1.0)
	ProjectSettings.set_setting("audio/music_volume", music_volume)
	_apply_volume(MUSIC_BUS, music_volume)
	volume_changed.emit(MUSIC_BUS, music_volume)


## Set SFX volume (linear 0.0-1.0)
func set_sfx_volume(linear_value: float) -> void:
	sfx_volume = clamp(linear_value, 0.0, 1.0)
	ProjectSettings.set_setting("audio/sfx_volume", sfx_volume)
	_apply_volume(SFX_BUS, sfx_volume)
	volume_changed.emit(SFX_BUS, sfx_volume)


## Set UI volume (linear 0.0-1.0)
func set_ui_volume(linear_value: float) -> void:
	ui_volume = clamp(linear_value, 0.0, 1.0)
	ProjectSettings.set_setting("audio/ui_volume", ui_volume)
	_apply_volume(UI_BUS, ui_volume)
	volume_changed.emit(UI_BUS, ui_volume)


## Toggle mute
func toggle_mute() -> void:
	is_muted = !is_muted
	AudioServer.set_bus_mute(get_bus_index(MASTER_BUS), is_muted)


## Apply all volume settings
func _apply_volumes() -> void:
	_apply_volume(MASTER_BUS, master_volume)
	_apply_volume(MUSIC_BUS, music_volume)
	_apply_volume(SFX_BUS, sfx_volume)
	_apply_volume(UI_BUS, ui_volume)


## Apply volume to specific bus (convert linear to dB)
func _apply_volume(bus_name: String, linear_value: float) -> void:
	var bus_index := get_bus_index(bus_name)
	if bus_index == -1:
		return
	
	var db_value := linear_to_db(linear_value)
	AudioServer.set_bus_volume_db(bus_index, db_value)


## Get bus index by name
func get_bus_index(bus_name: String) -> int:
	for i in range(AudioServer.bus_count):
		if AudioServer.get_bus_name(i) == bus_name:
			return i
	return -1


## Convert linear (0-1) to dB
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0
	return 20.0 * log(linear) / log(10)


## Get current volume as linear value
func get_volume_linear(bus_name: String) -> float:
	match bus_name:
		MASTER_BUS: return master_volume
		MUSIC_BUS: return music_volume
		SFX_BUS: return sfx_volume
		UI_BUS: return ui_volume
		_: return 0.0


## Save audio settings
func save_settings() -> void:
	ProjectSettings.save()


## Get music state for UI
func get_music_state() -> Dictionary:
	return {
		"is_playing": is_music_playing,
		"current_track": current_music_track,
		"volume": music_volume,
		"is_muted": is_muted
	}
