extends Label

func setTime (time: float) -> void:
	text = "%.3f" % time
	
	if time < 0 or time > 5:
		add_theme_color_override("font_color", Color.RED)
	else:
		add_theme_color_override("font_color", Color.WHITE)
