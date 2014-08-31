-module(mu2_case_mutations).

-export([all/0, case_mutations/0, random_not_n/2, swap/3]).

-include("../include/mutations.hrl").

-compile(nowarn_shadow_vars).

all() ->
    case_mutations().

case_mutations() ->
    [{swap_case_order,
      ?MUTATION_RESTRICT("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
			 length(Pats@@@) > 1),
      ?MUTATION("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
		begin
		    A = random:uniform(length(Pats@@@)),
		    B = random_not_n(length(Pats@@@), A),
		    NewPats@@@ = swap(Pats@@@, A, B),
		    NewGuards@@@ = swap(Guards@@@, A, B),
		    NewBody@@@ = swap(Body@@@, A, B),
		    ?TO_AST("case Expr@ of NewPats@@@ when NewGuards@@@ -> NewBody@@@ end")
		end)},
     {exchange_case_guard,
      ?MUTATION_RESTRICT("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
			 length(Pats@@@) > 1),
      ?MUTATION("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
		begin
		    A = random:uniform(length(Pats@@@)),
		    B = random_not_n(length(Pats@@@), A),
		    NewGuards@@@ = swap(Guards@@@, A, B),
		    ?TO_AST("case Expr@ of Pats@@@ when NewGuards@@@-> Body@@@ end")
		end)},
     {exchange_case_pattern,
      ?MUTATION_RESTRICT("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
			 length(Pats@@@) > 1),
      ?MUTATION("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
		begin
		    A = random:uniform(length(Pats@@@)),
		    B = random_not_n(length(Pats@@@), A),
		    NewPats@@@ = swap(Pats@@@, A, B),
		    ?TO_AST("case Expr@ of NewPats@@@ when Guards@@@-> Body@@@ end")
		end)},
     {remove_last_case,
      ?MUTATION_RESTRICT("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
			 length(Pats@@@) > 1),
      ?MUTATION("case Expr@ of Pats@@@ when Guards@@@ -> Body@@@ end",
		begin
		    NewPats@@@ = lists:sublist(Pats@@@, length(Pats@@@) -1),
		    NewGuards@@@ = lists:sublist(Guards@@@, length(Pats@@@) -1),
		    NewBody@@@ = lists:sublist(Body@@@, length(Pats@@@) -1),
		    
		    %% mu2_extras_server:add(?MUTATION("case NExpr@ of NPats@@@ when NGuards@@@ -> NBody@@@ end",
		    %% 				    begin
		    %% 					%% Put everything back...
		    %% 					?TO_AST("case Expr@ of Pats@@@ when Guards@@@-> Body@@@ end")
		    %% 				    end
		    %% 				   )),

		    ?TO_AST("case Expr@ of NewPats@@@ when NewGuards@@@-> NewBody@@@ end")
		end)}
    ].

random_not_n(1,1) ->
    exit("Called for a random number between 1 and 1 thats not 1...");
random_not_n(Range, Not) ->
    case random:uniform(Range) of
	Not ->
	    random_not_n(Range, Not);
	Val ->
	    Val
    end.

swap(List,S1,S2) -> 
    {List2,[F|List3]} = lists:split(S1-1,List),
    LT = List2++[lists:nth(S2,List)|List3],
    {List4,[_|List5]} = lists:split(S2-1,LT),
    List4++[F|List5].
