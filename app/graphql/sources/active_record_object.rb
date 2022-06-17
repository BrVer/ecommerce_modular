class Sources::ActiveRecordObject < GraphQL::Dataloader::Source
  def initialize(model_class, by_integer_field: :id, multiple: false)
    @model_class = model_class
    @by_integer_field = by_integer_field
    @multiple = multiple
  end

  def fetch(values)
    records = @model_class.where(@by_integer_field => values)
    @multiple ? map_one_to_many(values, records) : map_one_to_one(values, records)
  end

  private

  def map_one_to_one(values, records)
    values.map do |value|
      records.find { |r| r.public_send(@by_integer_field).to_i == value.to_i }
    end
  end

  def map_one_to_many(values, records)
    values.map do |value|
      records.select { |r| r.public_send(@by_integer_field).to_i == value.to_i }
    end
  end
end
