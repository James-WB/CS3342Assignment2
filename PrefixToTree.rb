#Author: James Bonvivere

class PrefixToTree
  attr_accessor :root

  def initialize(regex)
    @root
    string_array  = regex.split(//)
    children_array = []
    array_index = 0
    children_index = 0

    if string_array[0] == "("
      string_array.shift
      string_array.pop
    end

    while array_index != string_array.length
      if string_array.length == 1
        @root = Tree.new(string_array[array_index])
        break
      end

      if string_array[array_index] == "|" or string_array[array_index] == "+" or string_array[array_index] == "."
        @root = Tree.new(string_array[array_index])
        array_index+=1
        next
      end

      if /[a-zA-Z0-9]/.match(string_array[array_index])
        children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
        children_index+=1
        array_index+=1
        next
      end

      if string_array[array_index] == "("
        first_index = array_index
        bracket_counter = 1
        while bracket_counter != 0
          if string_array[array_index] == "("

            if array_index == first_index
              children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
              array_index+=1
              next
            end
            bracket_counter += 1
            children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
            array_index+=1
            next
          end

          if string_array[array_index] == ")"
            bracket_counter -= 1
            children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
            array_index+=1
            next
          end

          if string_array[array_index] =~ /[a-zA-Z]/
            children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
            array_index+=1
            next
          end
          if string_array[array_index].to_s == "." or string_array[array_index].to_s == "+" or string_array[array_index].to_s == "|"
            children_array[children_index] = children_array[children_index].to_s + string_array[array_index].to_s
            array_index+=1
            next
          end
        end
    children_index+=1
      end
    end

    children_array.each_index do |i|
      @root.subtrees.push(PrefixToTree.new(children_array[i].to_s).root)
    end
  end

  def to_tree
    root
  end

end


class Tree
  attr_accessor :subtrees, :root
  def initialize(value)
    @root = value
    @subtrees = []
  end
end