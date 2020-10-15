# frozen_string_literal: true

module Callable
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def call(*)
    raise NotImplementedError, "#{self.class} does not implement a #call method"
  end

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end
end
