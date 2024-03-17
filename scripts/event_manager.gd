extends Node

signal parasite_entered_exit(next_level:int)
signal parasite_died

signal level_change(person: Person)

signal parasite_in_dead_zone

signal open_dialog_box(text: String, portrait: CompressedTexture2D, char_name:String)
signal close_dialog_box
