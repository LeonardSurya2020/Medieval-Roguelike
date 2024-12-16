extends Node

var rng = RandomNumberGenerator.new()

func Woman_warrior():
	var random_number = rng.randi_range(1,4)
	print("You got : ", random_number)
	var text1 = ""
	print("this is witch from singleton GlobalNPCInteraction")

	if random_number == 1:
		text1 = "Wait.. i just see you in that corner"
	elif random_number == 2:
		text1 = "so you're the choosen one?"
	elif random_number == 3:
		text1 = "Im so tired..."
	elif random_number == 4:
		text1 = "I just wanna go home"

	return text1

func Witch():
	var random_number = rng.randi_range(1,5)
	print("You got : ", random_number)
	var text1 = ""
	print("this is witch from singleton GlobalNPCInteraction")

	if random_number == 1:
		text1 = "Hello Young man...."
	elif random_number == 2:
		text1 = "Whattt? so you're the choosen one?"
	elif random_number == 3:
		text1 = "This is Ridiculous..."
	elif random_number == 4:
		text1 = "What did i do wrong...."
	else:
		text1 = "This is Weird..."

	return text1


func Dwarf():
	var random_number = rng.randi_range(1,3)
	print("You got : ", random_number)
	var text1 = ""
	print("this is witch from singleton GlobalNPCInteraction")

	if random_number == 1:
		text1 = "HAHA! I know you're the choosen one"
	elif random_number == 2:
		text1 = "Dont worry. I will help you at the checkpoint"
	elif random_number == 3:
		text1 = "My hammer never stop..."

	return text1
