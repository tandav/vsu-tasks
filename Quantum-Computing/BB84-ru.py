# BB84 128 bit protocol

print("Условные обозначения:")
print("| q+ > = Q")
print("| q- > = q")
print("")

from random import randint
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

n = 128
# ----------------------------------------------------------------------
# Alice's random sequence:
A  = "10010010010010100100101001001010010010100100101001001010010010100100101001001010010101010010101010100101010011001001100101000000"
print("ALICE: моя последовательность:\n" + A + "\n")


# Alice's basis / machine sequence / gates:
AM = "HIIHIIIIIIIIHIIIHIIHIIHHIHIHIHIHIHIHIHHHHHIHIIIHIIIHIIIHIIIHIIHIIHIHHIHIHIHIHHIIHIIHHHHHHHHHHIIIIIIHHHIIIHIIHIIHIIIIIIHIIHIIIHHH"
print("ALICE: мои гейты:\n" + AM + "\n")

Am = ""
for i in range(n):
	if AM[i] == "H":
		Am += H(A[i])
	if AM[i] == "I":
		Am += I(A[i])

print("ALICE: после гейтов:\n" + Am + "\n")

BM = "IIHHHHIHHHIHIHHHIIIIHIIIHHHIHIIHIHIHIHHHIIHIHIIIIHIIHIIHHIIHHIHIHIHHHIHHIHIHHIHHIHHIIIIIIIHHIIIHIHIIIIHIHIIHHHIIIHHHIIIHHHIIIHHH"
print("BOB: мои гейты:\n" + BM + "\n")

Bm = ""
for i in range(n):
	if BM[i] == "H":
		Bm += H(Am[i])
	if BM[i] == "I":
		Bm += I(Am[i])

print("BOB: после гейтов:\n" + Bm + "\n")

B = ""
for b in Bm:
	if b == "Q" or b == "q":
		B += str(randint(0, 1))
	else:
		B += b

print("BOB: после измерения:\n" + B + "\n")

same_gates = [] # or same
for i in range(n):
	if AM[i] == BM[i]:
		same_gates.append(i)

A_check = ""
B_check = ""

for i in same_gates[:len(same_gates) // 2]:
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
	print("Test sequencies are not the same. There is a HACKER. Connection has been stopped.")

## Todo: Man In the Middle hijacking


