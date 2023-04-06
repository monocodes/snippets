# for Loop
PLANET = "Earth"
for i  in PLANET:
    print("Value of i is now", i)

print("Rest of the code.")

VACCINES = ("Moderna", "Pfizer", "Sputnik V", "Covaxin", "AstraZeneca")

for vac in VACCINES:
    print(f"{vac} vaccine provides immunization against covid19")

VACCINES = ["Moderna", "Pfizer", "Sputnik V", "Covaxin", "AstraZeneca"]

for vac in VACCINES:
    print(f"{vac} vaccine provides immunization against covid19")

# while Loop
x = 0
while x <= 10:
    print("Value of x is:", x)
    print("Looping")
    x += 1

print("Rest of the code.")
