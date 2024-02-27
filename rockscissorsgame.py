import random

player_wins = 0
computer_wins = 0
winning_score = 3
while player_wins < winning_score and computer_wins< winning_score:
	print(f"Player Score: {player_wins} Computer Score: {computer_wins}")
	print("Rock...")
	print("Paper...")
	print("Scissors...")

	player = input("Player 1, make your move: ").lower()
	if player == "quit" or player == "q":
		break
	rand_num = random.randint(0,2)
	if rand_num == 0:
		computer="rock"
	elif rand_num == 1:
		computer = "paper"
	else:
		computer = "scissors"
	print(computer)
	print(f"Computer plays {computer}")

	if player == computer:
		print("It's a tie!")

	elif player == "rock":
		if computer == "scissors":
			print("player wins!")
			player_wins += 1
		else:
			print("computer wins!")
			computer_wins += 1

	elif player == "paper":
		if computer == "scissors":
			print("computer wins!")
			computer_wins += 1
		else:
			print("player wins!")
			player_wins += 1

	elif player == "scissors":
		if computer == "rock":
			print("computer wins!")
			computer_wins += 1
		else:
			print("player wins!")
			player_wins += 1

	else:
		print("please enter a valid move")

if player_wins > computer_wins:
	print("Congrats,you won motherfucker!")
elif player_wins == computer_wins:
	print("such a boring draw, what's the point!")
else:
	print("shit, that bloody machine won the game that son of a bitch!")

print(f"FINAL SCORE... Player Score: {player_wins} Computer Score: {computer_wins}")