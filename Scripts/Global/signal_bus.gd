extends Node

signal update_health(node : Node, value : int)
signal update_respawn_pos(new_res_pos : Vector2)

signal update_score(value : int)

signal target_changed
signal beam_connect(target : Node)
signal beam_release
