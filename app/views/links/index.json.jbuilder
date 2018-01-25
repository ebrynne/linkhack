json.array!(@links) do |link|
  json.id link.id
  json.shortlink link.shortlink
  json.url link.url
  json.argsstr link.argsstr
  json.created_at link.created_at
  json.updated_at link.updated_at
  json.description link.description
  json.type link.type
end
