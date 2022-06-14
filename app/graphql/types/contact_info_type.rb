# frozen_string_literal: true

module Types
  class ContactInfoType < Types::BaseObject
    field :email, String, null: false
    field :phone, String, null: false
  end
end
