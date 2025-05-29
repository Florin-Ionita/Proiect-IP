extends Node

class_name Score

# The target points the player must reach
var goal: int = 0
var points: int = 0
var money: int = 0
var level: int = 1;

var high: int = 20

# Set the goal threshold
func set_goal(new_goal: int) -> void:
	goal = new_goal

func calculate_next_goal():
	goal = int(round(goal * 1.5 / 50.0)) * 50

func set_points(new_points: int):
	points = new_points

# Add points to the player; return true if goal reached or exceeded
func add_points(val: int) -> bool:
	points += val
	print("Player points: ", points)
	return points >= goal

func add_money(val: int):
	money += val
	
# Return False if you do not have enough money for something
func spend_money(val: int) -> bool:
	if money - val < 0:
		return false
	
	money -= val
	return true

# Tries to update the nigh
func set_high(new_high: int):
	if new_high < high:
		high = new_high
		
func calculate_money_gain():
	money += floor(high / 3)
