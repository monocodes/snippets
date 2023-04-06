# Arithmetic Operators
x = 2
y = 7

total = x + y
print(total)

total = x - y
print(total)

total = x * y
print(total)

total = y / x
print(total)

total = y % x
print(total)

total = y ** x
print(total)

# Comparison Operators

a = 30
b = 60

# You can safely put expression in paranthesis
out = (a < b)
print(out)

out = (a > b)
print(out)

out = (a == b)
print(out)

out = (a != b)
print(out)

out = (a >= b)
print(out)

out = (a <= b)
print(out)

# Assigment Operators
c = 0
d = 1

# c += d # c = c + d
# print(c)

c -= d # c = c - d
print(c)

# Logical Operators
# and
# or

a = 40
b = 60

x = 2
y = 3

out = (a < b) or (x > y)
print(out)

out = (a > b) or (x < y)
print(out)

out = (a > b) or (x > y)
print(out)

out = (a > b) and (x < y)
print(out)

out = (a < b) and (x < y)
print(out)

out = not (x < y)
print(out)

# Membership operator

first_tuple = ("IOT", "DevOps", 47, 89, 1.5)
ans = "DevOps" in first_tuple
print(ans)

ans = "DevOps" not in first_tuple
print(ans)

ans = 67 in first_tuple
print(ans)

ans = 47 not in first_tuple
print(ans)

ans = 67 not in first_tuple
print(ans)

# Identity operator
a = 12
b = 15

result = a is b
print(result)

result = a is not b
print(result)
