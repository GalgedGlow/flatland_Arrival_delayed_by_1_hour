import sys
from copy import deepcopy
from clingo import Control,Model, parse_term, Number
from clingo.application import clingo_main, Application
from clingo.script import enable_python
from clingo.symbol import Number, Function
import re

class RailSchedApp(Application):
    ctl: Control

    def on_find_first_model(self, model:Model):
        atoms = []
        for x in model.symbols(atoms = True):
        # for x in model.symbols():
            atoms.append(str(x))
        self.last_model = []
        # for atom in atoms:
        #     if re.search("hold\([\d]+,0\)", atom):
        #         new_atom = atom.replace(",0)", f",{self.answer_set_num+1})")
        #         self.last_model.append(new_atom)
            
    # def find_optimum_of_last_stored(self):
    #     # optimize Answer Set
    #     while not self.optimum_found:
    #         add_string = '\n'.join(atom + "." for atom in self.last_model) + f"\n:- better{self.answer_set_num+1}, not better(0,{self.answer_set_num+1}). #external better{self.answer_set_num+1}."
    #         self.ctl.add(f"m{self.answer_set_num+1}", [], add_string)
    #         self.ctl.ground([(f"m{self.answer_set_num+1}", []), ("preference", [Number(0), Number(self.answer_set_num+1)])])
    #         self.ctl.assign_external(parse_term(f"better{self.answer_set_num+1}"), True)
    #         self.answer_set_num += 1
    #         ret = self.ctl.solve(on_model=self.on_find_first_model)
    #         self.optimum_found = not ret.satisfiable
    #         self.ctl.assign_external(parse_term(f"better{self.answer_set_num}"), False) #release_external
    #     print("OPTIMUM FOUND")
    #     self.optimums_found += 1
    #     self.optimum_found = False
    
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

        # Find first Answer Set

        # max_wait_restriction = ":- max_wait_actions(N), action_wait_count(C), N <= C."
        # self.ctl.add("base", [], max_wait_restriction)

        # max_wait_actions = 1
        # max_wait_atom = f"max_wait_actions({max_wait_actions})."
        # self.ctl.assign_external(parse_term(max_wait_atom), True)
        # generate_waits = "{ action(train(ID), wait, T+1) } <= 1 :- occupation(train(ID), _, T, _), end(ID, _, Arr), T < Arr, AC = #count{ 1, TA, TID : action(TID, wait, TA ) }, max_wait_atom(MW), AC < MW."
        # f"max_wait_actions({max_wait_actions})"
        
        train_atom = "train(0). start(0,(13,20),6,w) :- train_0. end(0,(10,33),54) :- train_0. #external train_0."
        self.ctl.add("base", [], train_atom)

        self.ctl.ground([("base", [])])
        self.ctl.assign_external(parse_term("train_0"), True)

        self.ctl.solve(on_model=self.on_find_first_model)
        
        
        # self.find_optimum_of_last_stored()

        # while max_models != self.optimums_found:
        # # while True:  
        #     add_string_2 = f":- not_better{self.answer_set_num}, better({self.answer_set_num},0). #external not_better{self.answer_set_num}."
        #     self.ctl.add(f"not_better{self.answer_set_num}", [], add_string_2)
        #     self.ctl.ground([(f"not_better{self.answer_set_num}", []), ("preference", [Number(self.answer_set_num), Number(0)]), ("delete", [Number(self.answer_set_num)])])
        #     for i in range(1, self.answer_set_num+1):
        #         self.ctl.assign_external(parse_term(f"not_better{i}"), True)

        #     ret = self.ctl.solve(on_model=self.on_find_first_model)
        #     if not ret.satisfiable:
        #         break

        #     for i in range(1, self.answer_set_num+1):
        #         self.ctl.assign_external(parse_term(f"not_better{i}"), False)

        #     self.find_optimum_of_last_stored()
            
        # print("ALL ANSWERS FOUND")
        # print(f"Total number of optimized models: {self.optimums_found}")

if __name__ == "__main__":
    clingo_main(RailSchedApp(), sys.argv[1:])
