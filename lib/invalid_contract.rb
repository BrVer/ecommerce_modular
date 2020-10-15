# frozen_string_literal: true

class InvalidContract < ArgumentError
  def initialize(contract_errors)
    @contract_errors = contract_errors
    super(nil)
  end

  attr_reader :contract_errors
end
