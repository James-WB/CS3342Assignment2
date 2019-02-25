#Author: Robert Webber

class String
  def category
    return "L" if self =~ /[a-zA-Z]/
    return "D" if self =~ /[0-9]/
    return "Q" if self == "?"
    return "E" if self == "!"
    return "P" if self == "."
    return "C" if self == ","
    return "K" if self == ":"
    return "M" if self == "-"
    return "A" if self == "+"
    return "B" if self =~ /[\*\/\%\^]/
    return "X" if self == "("
    return "Y" if self == ")"
    return "S" if self == "="
    return "T" if self == "<"
    return "U" if self == ">"
    "Z"
  end
end

class NFAScanner
  def initialize(nfa)
    @nfa = nfa
  end
  def match(string)
    state = @nfa.start
    match_helper(state, string)
  end

  private

  def match_helper(state, string)
    current_states = [ state ] + @nfa.epsilon_closure(state)
    return accepting?(current_states)  if string.empty?
    next_states = move_forward(string[0].category, current_states)
    return false if next_states.empty?
    match_helper_try(next_states, string[1..-1])
  end
  def accepting?(states)
    states.any? { | state | state.accepting? }
  end
  def move_forward(category, states)
    forward = []
    states.each do | state |
      forward = forward + @nfa.next(state,category)
    end
    forward
  end
  def match_helper_try(states, string)
    states.any? do | state |
      match_helper(state, string)
    end
  end
end