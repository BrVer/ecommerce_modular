# frozen_string_literal: true

module Orders
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
  end
end
