json.array!(@movers) do |mover|
  json.extract! mover, :id, :name, :dob, :gender, :expertise, :cma_like_training, :other_training
  json.url mover_url(mover, format: :json)
end
