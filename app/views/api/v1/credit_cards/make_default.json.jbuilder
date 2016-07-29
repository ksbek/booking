json.array!(@cards) do |card|
  json.merge! card.attributes
end
