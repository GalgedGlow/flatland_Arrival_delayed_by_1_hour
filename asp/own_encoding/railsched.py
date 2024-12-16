import sys
from copy import deepcopy
from clingo import Control,Model, parse_term, Number
from clingo.application import clingo_main, Application
from clingo.script import enable_python
from clingo.symbol import Number, Function
import re
import subprocess

CRASH_CONSTRAINT =  """
                    :- occupation(train(ID1), (X,Y), T, _), occupation(train(ID2), (X,Y), T, _), ID1 < ID2.
                    :- occupation(train(ID1), (X1,Y1), T, _), occupation(train(ID2), (X2,Y2), T, _), occupation(train(ID1), (X2,Y2), T+1, _), occupation(train(ID2), (X1,Y1), T+1, _), ID1 < ID2.
                    """

class Agent:
    train: str
    start: str
    end: str

    def __init__(self, train, start, end):
        self.train = train
        self.start = start
        self.end = end

class AssertApp(Application):
    ctl: Control

    def main(self, ctl, files):
        self.ctl = ctl
        if not files:
            self.ctl.load("-")
        else:
            for file in files:
                self.ctl.load(file)
        self.ctl.ground()
        SAT = self.ctl.solve().satisfiable

class RailSchedApp(Application):
    ctl: Control
    # last_agent_model: str = ""
    # last_model: list = []
    assert_content = ""

    current_agent: int = 0
    agent_atoms_history: list[list[str]] = []

    def on_model(self, model:Model):
        if(len(self.agent_atoms_history) <= self.current_agent):
            self.agent_atoms_history.append([])

        last_agent_model = CRASH_CONSTRAINT
        for s in model.symbols(atoms = True):
            a = str(s)
            if "occupation(" in a:
                last_agent_model += a + "."
        self.agent_atoms_history[self.current_agent].append(last_agent_model)
    
    def main(self, ctl, files):
        #Setup
        self.ctl = ctl
        # max_models = int(self.ctl.configuration.solve.models)
        # self.ctl.configuration.solve.models = 1
        if not files:
            self.ctl.load("-")
        else:
            for file in files:
                self.ctl.load(file)

        # self.last_model = []
        # self.last_model.append(CRASH_CONSTRAINT)
        self.assert_content += CRASH_CONSTRAINT

        # Find first Answer Set

        # max_wait_restriction = ":- max_wait_actions(N), action_wait_count(C), N <= C."
        # self.ctl.add("base", [], max_wait_restriction)

        # max_wait_actions = 1
        # max_wait_atom = f"max_wait_actions({max_wait_actions})."
        # self.ctl.assign_external(parse_term(max_wait_atom), True)
        # generate_waits = "{ action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, _, Arr), T < Arr, AC = #count{ 1, TA, TID : action(TID, wait, TA ) }, max_wait_atom(MW), AC < MW."
        # f"max_wait_actions({max_wait_actions})"

        agents = [
            Agent("train(0)", "start(0,(13,20),6,w)", "end(0,(10,33),54)"),
            Agent("train(1)", "start(1,(9,33),0,e)", "end(1,(14,20),58)"),
            Agent("train(2)", "start(2,(9,33),2,e)", "end(2,(16,20),63)"),
            Agent("train(3)", "start(3,(13,20),2,w)", "end(3,(12,33),53)"),
        ]


        for i in range(0, len(agents)):
            train_atom = f"{agents[i].train}. {agents[i].start} :- train_{i}. {agents[i].end} :- train_{i}. #external train_{i}."
        
        # train_atom = "train(0). start(0,(13,20),6,w) :- train_0. end(0,(10,33),54) :- train_0. #external train_0."
            self.ctl.add("base", [], train_atom)
        
        self.ctl.ground([("base", [])])

        for i in range(0, len(agents)):
            self.current_agent = i
            self.ctl.assign_external(parse_term(f"train_{i}"), True)
            self.ctl.solve(on_model=self.on_model)
            self.ctl.assign_external(parse_term(f"train_{i}"), False)

        ### Assert Trains work together

        # self.ctl.add("assert", [], CRASH_CONSTRAINT)
        
        # for last_model in self.last_models:
        #     for atom in last_model:
        #         self.ctl.add("assert", [], atom + ".")
        # self.ctl.ground([("assert", [])])
        # SAT = self.ctl.solve().satisfiable
        # assert SAT == True

#         flat_atom_list = [
#             atom
#             for last_model in self.last_model
#             for atom in last_model
# ]


        for i in range(0, len(self.agent_atoms_history)):
            self.agent_atoms_history[i] = list(reversed(self.agent_atoms_history[i]))

        max_i = min(10, len(self.agent_atoms_history[0]))
        max_j = min(10, len(self.agent_atoms_history[1]))
        max_k = min(10, len(self.agent_atoms_history[2]))
        max_l = min(10, len(self.agent_atoms_history[3]))

        for i in range(0, max_i):
            for j in range(0, max_j):
                for k in range(0, max_k):
                    for l in range(0, max_l):
                        assert_content = self.agent_atoms_history[0][i] + self.agent_atoms_history[1][j] + self.agent_atoms_history[2][k] + self.agent_atoms_history[3][l]

                        assert_file = open("assert.lp", "w")
                        assert_file.write(assert_content)
                        assert_file.close()
                        SAT = clingo_main(AssertApp(), ["assert.lp"])
                        if SAT == 1:
                            print("SAT") #20 = UNSAT?



if __name__ == "__main__":
    clingo_main(RailSchedApp(), sys.argv[1:])
