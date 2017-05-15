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
# XM = "IIHIIHIHIHIIHIIIHIIIHIIHIHIIHIIHIIIHIHIIIHIHIHIHIIHIHHIHIHIHIHIHIHIHIIIHIIIHIIIHIIIIHIHHIHIIHIIHHHIIHHIIHIHIHIHHIHIHHIIHIIIHIIII"
# print("X: мои гейты gates:\n" + XM + "\n")
# Xm = ""
# for i in range(n):
# 	if XM[i] == "H":
# 		Xm += H(Am[i])
# 	if XM[i] == "I":
# 		Xm += I(Am[i])
# print("X: после гейтов:\n" + Xm + "\n")

# X = ""
# for x in Xm:
# 	if x == "Q" or x == "q":
# 		X += str(randint(0, 1))
# 	else:
# 		X += x
# print("X: после измерения:\n" + X + "\n")

# Xm = ""
# for i in range(n):
# 	if XM[i] == "H":
# 		Xm += H(X[i])
# 	if XM[i] == "I":
# 		Xm += I(X[i])
# print("X: после повторного применения гейтов:\n" + Xm + "\n")
# Am = Xm

B   = "1011001011001101"
print("BOB: моя последовательность b:\n" + B + "\n")

BO  = "PpPpppPpPPppPPpP"
print("BOB: мои операторы:\n" + BO + "\n")

Bm = ""
for i in range(n):
	if BO[i] == "P":
		Bm += P(Aq[i])
	if BO[i] == "p":
		Bm += p(Aq[i])

print("BOB: после действия операторов:\n" + Bm + "\n")

B_measure = ""
for b in Bm:
	if b == "Q" or b == "q":
		B_measure += str(randint(0, 1))
	else:
		B_measure += b

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
	key = ""
	for i in same_gates[len(same_gates) // 2:]:
		key += A[i]
	print(key)
else:
	print("Тестовые последовательности НЕ совпадают. Было подслушивание.")

## Todo: Man In the Middle hijacking


