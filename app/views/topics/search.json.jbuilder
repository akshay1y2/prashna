json.array! @topics do |topic|
  json.extract! topic, :id, :name
  json.label topic.name
end
