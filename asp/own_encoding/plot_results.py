from matplotlib import pyplot as plt

# size 40x40
# results:    cell-based    graph-based
# agents:     5.249(37)     0.062(37)
# 1           7.116(74)     0.098(74)
# 2           123.139(183)  
# 3
# 4
# 5

agents = list(range(0, 5))
cell_based = [5.249, 7.116, 123.139]
graph_based = [0.062, 0.098, ]

plt.plot(agents, cell_based)
plt.plot(agents, graph_based)

plt.show()