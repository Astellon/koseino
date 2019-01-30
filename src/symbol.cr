module Koseino
  alias Type = Int32

  class Identifier
    getter name : String
    getter value : Type
    def initialize(@name, @value)
    end
  end

  class SymbolTable
    getter identifiers
    def initialize
      @identifiers = Array(Identifier).new
    end

    def add(id : Identifier)
      @identifiers << id
      return self
    end

    def <<(id : Identifier)
      add(id)
    end

    def get(name : String)
      identifiers.each do |id|
        return id if id.name == name
      end
      abort("Not Found")
    end
  end
end
