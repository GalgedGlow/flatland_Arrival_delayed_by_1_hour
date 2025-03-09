by_timestep = """
 forced_action(train(0),wait,0).
 forced_action(train(1),wait,0).
 forced_action(train(0),wait,1).
 forced_action(train(1),wait,1).
 forced_action(train(0),wait,2).
 forced_action(train(1),wait,2).
 forced_action(train(0),wait,3).
 forced_action(train(1),move_forward,3).
 forced_action(train(0),wait,4).
 forced_action(train(1),move_forward,4).
 forced_action(train(0),wait,5).
 forced_action(train(1),move_forward,5).
 forced_action(train(0),wait,6).
 forced_action(train(1),move_forward,6).
 forced_action(train(0),wait,7).
 forced_action(train(1),move_left,7).
 forced_action(train(0),wait,8).
 forced_action(train(1),move_forward,8).
 forced_action(train(0),wait,9).
 forced_action(train(1),move_forward,9).
 forced_action(train(0),wait,10).
 forced_action(train(1),wait,10).
 forced_action(train(0),wait,11).
 forced_action(train(1),wait,11).
 forced_action(train(0),wait,12).
 forced_action(train(1),wait,12).
 forced_action(train(0),wait,13).
 forced_action(train(1),wait,13).
 forced_action(train(0),wait,14).
 forced_action(train(1),wait,14).
 forced_action(train(0),move_forward,15).
 forced_action(train(1),move_forward,15).
 forced_action(train(0),move_forward,16).
 forced_action(train(1),move_forward,16).
 forced_action(train(0),move_forward,17).
 forced_action(train(1),wait,17).
 forced_action(train(0),move_forward,18).
 forced_action(train(1),wait,18).
 forced_action(train(0),move_forward,19).
 forced_action(train(1),wait,19).
 forced_action(train(0),move_forward,20).
 forced_action(train(1),wait,20).
 forced_action(train(0),move_forward,21).
 forced_action(train(1),wait,21).
 forced_action(train(0),move_forward,22).
 forced_action(train(1),wait,22).
 forced_action(train(0),move_forward,23).
 forced_action(train(1),move_forward,23).
 forced_action(train(0),move_forward,24).
 forced_action(train(1),move_forward,24).
 forced_action(train(0),move_forward,25).
 forced_action(train(1),move_forward,25).
 forced_action(train(0),move_forward,26).
 forced_action(train(1),move_forward,26).
 forced_action(train(0),move_forward,27).
 forced_action(train(1),move_forward,27).
 forced_action(train(0),move_forward,28).
 forced_action(train(1),move_forward,28).
 forced_action(train(0),move_forward,29).
 forced_action(train(1),move_forward,29).
 forced_action(train(0),move_forward,30).
 forced_action(train(1),move_forward,30).
 forced_action(train(0),wait,31).
 forced_action(train(1),wait,31).
 forced_action(train(0),wait,32).
 forced_action(train(1),wait,32).
 forced_action(train(0),wait,33).
 forced_action(train(1),wait,33).
 forced_action(train(0),wait,34).
 forced_action(train(1),wait,34).
 forced_action(train(0),move_forward,35).
 forced_action(train(1),wait,35).
 forced_action(train(0),move_forward,36).
 forced_action(train(1),move_forward,36).
 forced_action(train(0),move_forward,37).
 forced_action(train(1),move_forward,37).
 forced_action(train(0),move_forward,38).
 forced_action(train(1),move_forward,38).
 forced_action(train(0),move_forward,39).
 forced_action(train(1),move_forward,39).
 forced_action(train(0),move_forward,40).
 forced_action(train(1),move_forward,40).
 forced_action(train(0),move_forward,41).
 forced_action(train(1),move_forward,41).
 forced_action(train(0),move_forward,42).
 forced_action(train(1),move_forward,42).
 forced_action(train(0),move_forward,43).
 forced_action(train(1),wait,43).
 forced_action(train(0),move_forward,44).
 forced_action(train(1),wait,44).
 forced_action(train(0),move_forward,45).
 forced_action(train(1),wait,45).
 forced_action(train(1),wait,46).
 forced_action(train(1),wait,47).
 forced_action(train(0),wait,46).
 forced_action(train(0),wait,47).
 forced_action(train(0),wait,48).
 forced_action(train(0),wait,49).
 malfunction_extra_time(1, 3).
 malfunction(1,3,0).
 malfunction_extra_time(1, 8).
 malfunction(1,5,10).
 malfunction_extra_time(1, 14).
 malfunction(1,6,17).
 malfunction_extra_time(1, 19).
 malfunction_extra_time(0, 4).
 malfunction(0,4,31).
 malfunction(1,5,31).
 malfunction_extra_time(1, 24).
 malfunction_extra_time(0, 4).
 malfunction(1,5,43).
 malfunction_extra_time(1, 26).
 malfunction_extra_time(0, 8).
 malfunction(1,2,46).
 malfunction(0,4,46).

"""

agents  = {}

for i in range(0, 10):
    agents[i] = {}

for action in by_timestep.split('\n'):
    for i in range(0, 10):
        if f"train({i})" in action:
            t_i = int(action.split(',')[-1][:-2])
            agents[i][t_i] = action
            agents[i] = dict(sorted(agents[i].items()))

by_agents = ""

for agent in agents.values():
    for timestep in agent.values():
        by_agents += timestep
        by_agents += '\n'

############ one line #################################

by_timestep_one_line = "action(train(0),wait,0) action(train(0),wait,1) action(train(0),wait,2) action(train(0),wait,3) action(train(0),wait,4) action(train(0),wait,5) action(train(0),wait,6) action(train(0),wait,7) action(train(0),wait,8) action(train(0),wait,9) action(train(0),wait,10) action(train(0),wait,11) action(train(0),wait,12) action(train(0),wait,13) action(train(0),wait,14) action(train(1),wait,0) action(train(1),wait,1) action(train(1),wait,2) action(train(0),move_forward,15) action(train(1),move_forward,3) action(train(1),wait,43) action(train(1),wait,44) action(train(1),wait,45) action(train(1),wait,46) action(train(1),wait,47) action(train(1),wait,52) action(train(1),wait,53) action(train(1),wait,54) action(train(1),wait,10) action(train(1),wait,11) action(train(1),wait,12) action(train(1),wait,13) action(train(1),wait,14) action(train(1),wait,17) action(train(1),wait,18) action(train(1),wait,19) action(train(1),wait,20) action(train(1),wait,21) action(train(1),wait,22) action(train(0),wait,31) action(train(0),wait,32) action(train(0),wait,33) action(train(0),wait,34) action(train(1),wait,31) action(train(1),wait,32) action(train(1),wait,33) action(train(1),wait,34) action(train(1),wait,35) action(train(0),wait,46) action(train(0),wait,47) action(train(0),wait,48) action(train(0),wait,49) action(train(0),wait,54) action(train(0),wait,55) action(train(0),wait,56) action(train(1),wait,70) action(train(1),wait,71) action(train(1),wait,72) action(train(1),wait,73) action(train(1),wait,74) action(train(1),wait,75) action(train(0),move_forward,16) action(train(1),move_forward,4) action(train(1),move_forward,6) action(train(0),move_forward,17) action(train(1),move_forward,7) action(train(0),move_forward,18) action(train(1),move_forward,8) action(train(0),move_forward,20) action(train(0),move_forward,22) action(train(0),move_forward,23) action(train(0),move_forward,28) action(train(0),move_forward,27) action(train(0),move_forward,29) action(train(0),move_forward,45) action(train(1),move_forward,38) action(train(1),move_forward,39) action(train(1),move_forward,40) action(train(0),move_forward,50) action(train(1),move_forward,41) action(train(0),move_forward,51) action(train(1),move_forward,42) action(train(0),move_forward,52) action(train(0),move_forward,53) action(train(1),move_forward,48) action(train(1),move_forward,49) action(train(0),move_forward,57) action(train(1),move_forward,50) action(train(0),move_forward,58) action(train(1),move_forward,51) action(train(0),move_forward,60) action(train(0),move_left,59) action(train(0),move_forward,61) action(train(1),move_forward,55) action(train(0),move_forward,63) action(train(1),move_forward,56) action(train(0),move_left,62) action(train(1),move_forward,57) action(train(1),move_forward,58) action(train(1),move_forward,59) action(train(1),move_forward,60) action(train(1),move_forward,61) action(train(1),move_forward,62) action(train(1),move_forward,63) action(train(1),move_forward,64) action(train(1),move_forward,65) action(train(1),move_forward,66) action(train(1),move_forward,67) action(train(1),move_forward,68) action(train(1),move_forward,69) action(train(1),move_forward,76) action(train(1),move_forward,77) action(train(1),move_forward,78) action(train(1),move_forward,80) action(train(1),move_right,79) action(train(1),move_forward,5) action(train(0),move_forward,19) action(train(1),move_forward,9) action(train(0),move_forward,21) action(train(0),move_forward,24) action(train(0),move_forward,25) action(train(0),move_forward,26) action(train(1),move_forward,15) action(train(1),move_forward,16) action(train(1),move_forward,23) action(train(1),move_forward,24) action(train(1),move_forward,25) action(train(1),move_forward,26) action(train(1),move_forward,27) action(train(1),move_forward,28) action(train(1),move_forward,29) action(train(1),move_forward,30) action(train(1),move_forward,36) action(train(1),move_forward,37) action(train(0),move_forward,30) action(train(0),move_forward,35) action(train(0),move_forward,36) action(train(0),move_forward,37) action(train(0),move_forward,38) action(train(0),move_forward,39) action(train(0),move_forward,40) action(train(0),move_forward,41) action(train(0),move_forward,42) action(train(0),move_forward,43) action(train(0),move_forward,44)"

agents_one_line = {}

for i in range(0, 10):
    agents_one_line[i] = {}

for action in by_timestep_one_line.split(' '):
    for i in range(0, 10):
        if f"train({i})" in action:# or 
        # if "malfunction" in action:
            t_i = int(action.split(',')[-1][:-1])
            agents_one_line[i][t_i] = action
            agents_one_line[i] = dict(sorted(agents_one_line[i].items()))

# for agent in agents_one_line.values():
#     for timestep in agent:
#         int(timestep.split(',')[-1][:-1])

# agents_one_line = dict(sorted(agents_one_line.items()))

by_agents_one_line = ""

# for agent in agents_one_line.values():
for agent in agents_one_line.values():
    for timestep in agent.values():
        by_agents_one_line += timestep
        by_agents_one_line += '\n'

#################################### just split new lines ###################################

one_line = "chosen_move(0,(14,32),(14,31),16,17,0,w,w,move_forward) chosen_move(1,(21,7),(22,6),4,6,0,w,s,move_forward) chosen_move(1,(22,6),(22,5),6,7,0,s,w,move_forward) chosen_move(0,(14,31),(14,30),17,18,0,w,w,move_forward) chosen_move(1,(22,5),(22,4),7,8,0,w,w,move_forward) chosen_move(0,(14,30),(13,29),18,20,0,w,n,move_forward) chosen_move(0,(13,29),(13,27),20,22,0,n,w,move_forward) chosen_move(0,(13,27),(13,26),22,23,0,w,w,move_forward) chosen_move(0,(13,26),(17,25),23,28,0,w,s,move_forward) chosen_move(0,(17,25),(18,25),28,29,0,s,s,move_forward) chosen_move(0,(18,25),(21,12),29,53,0,s,s,move_forward) chosen_move(0,(21,12),(22,12),53,54,0,s,s,move_forward) chosen_move(0,(22,10),(23,9),59,61,0,w,w,move_left) chosen_move(0,(22,12),(22,10),54,59,0,s,w,move_forward) chosen_move(0,(23,9),(23,8),61,62,0,w,w,move_forward) chosen_move(1,(22,4),(17,25),8,62,0,w,e,move_forward) chosen_move(0,(23,8),(24,7),62,64,0,w,w,move_left) chosen_move(1,(17,25),(13,26),62,67,0,e,e,move_forward) chosen_move(1,(13,26),(13,27),67,68,0,e,e,move_forward) chosen_move(1,(13,27),(13,29),68,70,0,e,e,move_forward) chosen_move(1,(13,29),(14,30),70,78,0,e,e,move_right) chosen_move(1,(14,30),(14,31),78,79,0,e,e,move_forward) chosen_move(1,(14,31),(15,32),79,81,0,e,e,move_right)"
connector = ["(",")"]

by_line = "\n".join(one_line.split(' '))

print(by_agents_one_line)
# print(by_agents)
# print(by_line)