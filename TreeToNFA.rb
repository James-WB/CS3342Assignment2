#Author: James Bonvivere
#Student Number: 250906910
# CS 3342 - Assignment 1

class TreeToNFA
  attr_accessor :start, :ending_state

  def initialize(input_tree, input_start = nil, input_end_state = nil)
    root = input_tree.root

    if input_start == nil
      input_start = @start = State.new
    else
      @start = input_start
    end


    if input_end_state
      if root =~ /[a-zA-Z]/
        edge = Edge.new(input_start,input_end_state, root)
        input_start.edge_array.append(edge)
        @ending_state = edge.ending
        input_start.accept = false
      end

      if root == "."
        current_state = input_start
        input_tree.subtrees.each_index do |i|
          current_state = TreeToNFA.new(input_tree.subtrees[i],current_state).ending_state
        end
        @ending_state = current_state
      end


      if root == "|"
        union_last_state = State.new
        input_tree.subtrees.each_index do |i|
          TreeToNFA.new(input_tree.subtrees[i], input_start, union_last_state)
          @ending_state = union_last_state
        end
      end

      if root == "+"
        edge = Edge.new(input_start,input_end_state, root)
        input_start.edge_array.append(edge)
        @ending_state = edge.ending
        input_start.accept = false
      end

      return
    end


    if root =~ /[a-zA-Z]/
      edge = Edge.new(input_start,State.new, root)
      input_start.edge_array.append(edge)
      input_start.accept = false
      @ending_state = edge.ending
    end

    if root == "."
      current_state = input_start
      input_tree.subtrees.each_index do |i|
        current_state = TreeToNFA.new(input_tree.subtrees[i],current_state).ending_state
      end
      @ending_state = current_state
    end

    if root == "|"
      union_last_state = State.new
      input_tree.subtrees.each_index do |i|
        TreeToNFA.new(input_tree.subtrees[i], input_start, union_last_state)
        @ending_state = union_last_state
      end
    end

    if root == "+"
      new_end_state = State.new
      edge = Edge.new(input_start,new_end_state, "e")
      input_start.edge_array.append(edge)
      input_start.accept = false
      next_state = TreeToNFA.new(input_tree.subtrees[0],new_end_state).ending_state
      edge2 = Edge.new(next_state,new_end_state, "e")
      next_state.edge_array.append(edge2)
      next_state.accept = false
      last_node = State.new
      edge3 = Edge.new(next_state,last_node, "e")
      next_state.edge_array.append(edge3)
      next_state.accept = false
      @ending_state = last_node
    end

  end


  def to_nfa
    @start
  end

end


class State
  attr_accessor :accept, :edge_array, :start

  def initialize
    @accept = true
    @edge_array = []
    @start = self
  end


  def next(state, category)
    next_array = []
    state.edge_array.each_index do |i|
      if state.edge_array[i].transition == category
        next_array.append(state.edge_array[i].ending)
      end
    end
    next_array
  end


  def accepting?
    accept
  end


  def epsilon_closure(state)
    epsilon_array = []
    state.edge_array.each_index do |i|
      if state.edge_array[i].transition == "e"
        epsilon_array.append(state.edge_array[i].ending)
      end
    end
    epsilon_array
  end

end


class Edge
  attr_accessor :starting, :ending, :transition
  def initialize(starting, ending, transition)
    @starting = starting
    @ending = ending
    @transition = transition
  end
end