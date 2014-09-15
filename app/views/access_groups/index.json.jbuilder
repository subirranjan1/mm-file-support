json.array!(@access_groups) do |access_group|
  json.extract! access_group, :id, :name, :creator_id
  json.url access_group_url(access_group, format: :json)
end
