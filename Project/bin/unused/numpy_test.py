
import numpy

a = [1]*30
a = [a]
print(a)

b = []
for k in range(0, 20):
	b.append([3])
print(b)

bb = numpy.reshape(b, (20,1))
print(bb)

c = numpy.dot(b, a)
print(c)