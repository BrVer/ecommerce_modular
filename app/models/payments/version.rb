# frozen_string_literal: true

module Payments
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
  end
end
