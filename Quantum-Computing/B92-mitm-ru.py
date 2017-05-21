# BB84 128 bit protocol

print("Условные обозначения:")
print("| q+ > = Q")
print("| q- > = q")
print("  P1   = P")
print("  P_   = p")
print("")



from random import randint

def A_device(x):
    return {
        "0": "0",
        "1": "Q",
    }[x]

def P(x):
    return {
        "Q": "0",
        "0": "0",
    }[x]

def p(x):
    return {
        "Q": "0",
        # "Q": "N",
        "0": "Q",
    }[x]

def H(x):
    return {
        "Q": "0",
        "q": "1",
        "0": "Q",
        "1": "q",
    }[x]

def I(x):
	return x
    # return {
    #     "Q": "Q",
    #     "q": "q",
    #     "0": "0",
    #     "1": "1",
    # }[x]

n = 16
# ----------------------------------------------------------------------
# Alice's random sequence:
A  = "1000010011010001"
print("ALICE: моя последовательность:\n" + A + "\n")

# Alice's Q-bits:
Aq = ""
for b in A:
	if b == "0":
		Aq += "0"
	if b == "1":
		Aq += "Q"

# Alice's basis / machine sequence / gates:
print("ALICE: сгенерированные кубиты:\n" + Aq + "\n")


# # X: Hacker in the middle
# X   = "0011101010010110"
# print("X: моя последовательность b:\n" + X + "\n")

# XO  = "pppPPPppPPpPPpPp"
# print("X: мои операторы:\n" + XO + "\n")

# Xq = ""
# for i in range(n):
# 	if XO[i] == "P":
# 		Xq += P(Aq[i])
# 	if XO[i] == "p":
# 		Xq += p(Aq[i])
# print("X: после действия операторов:\n" + Xq + "\n")

# X_measure = ""
# for q in Xq:
# 	if q == "Q" or q == "q":
# 		X_measure += str(randint(0, 1))
# 	else:
# 		X_measure += q
# print("X: после измерения:\n" + X_measure + "\n")

# Aq = Xq

# # End Hacker



B   = "1011001011001101"
print("BOB: моя последовательность b:\n" + B + "\n")

BO  = "PpPpppPpPPppPPpP"
print("BOB: мои операторы:\n" + BO + "\n")

Bq = ""
for i in range(n):
	if BO[i] == "P":
		Bq += P(Aq[i])
	if BO[i] == "p":
		Bq += p(Aq[i])
print("BOB: после действия операторов:\n" + Bq + "\n")

B_measure = ""
for q in Bq:
	if q == "Q" or q == "q":
		B_measure += str(randint(0, 1))
	else:
		B_measure += q
print("BOB: после измерения:\n" + B_measure + "\n")

same_gates = [] # or same
for i in range(n):
	if B_measure[i] == "1":
		same_gates.append(i)

A_check = ""
B_check = ""

for i in same_gates:
	A_check += A[i]
	B_check += B[i]

print("ALICE: тестовая последовательность:\n" + A_check + "\n")
print("BOB: тестовая последовательность:\n" + B_check + "\n")

if A_check == B_check:
	print("Тестовые последовательности совпадают. Ключ:")
	print(A_check)
	# key = ""
	# for i in same_gates[len(same_gates) // 2:]:
		# key += A[i]
	# print(key)
else:
	print("Тестовые последовательности НЕ совпадают. Было подслушивание.")

## Todo: Man In the Middle hijacking


