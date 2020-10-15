# frozen_string_literal: true

module Inventory
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
  end
end
