json.array!(@movement_annotations) do |movement_annotation|
  json.extract! movement_annotation, :id, :name, :description, :format
  json.url movement_annotation_url(movement_annotation, format: :json)
end
