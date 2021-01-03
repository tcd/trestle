module Trestle
  class Builder

    # @param name [Doc::Unknown]
    #
    # @return [Doc::Unknown]
    def self.target(name)
      attr_reader name
      alias_method :target, name
    end

    # @param *args [Doc::Unknown]
    # @param &block [Proc]
    #
    # @return [Doc::Unknown]
    def self.build(*args, &block)
      new(*args).build(&block)
    end

    # @param &block [Proc]
    #
    # @return [Doc::Unknown]
    def build(&block)
      instance_eval(&block) if block_given?
      target
    end
  end
end
