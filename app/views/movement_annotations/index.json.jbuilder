json.array!(@movement_annotations) do |movement_annotation|
  json.extract! movement_annotation, :id, :name, :description, :format, :public
	json.owner_url user_url(movement_annotation.owner, format: :json)
  json.url movement_annotation_url(movement_annotation, format: :json)
end
