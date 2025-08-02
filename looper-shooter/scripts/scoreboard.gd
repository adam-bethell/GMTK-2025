extends Control


var p1score = 0
var p2score = 0

func addPoint(p: int) -> void:
	if p == 1:
		p1score += 1
		$p1Score.text = "%d" % p1score
	else:
		p2score += 1
		$p2Score.text = "%d" % p2score
