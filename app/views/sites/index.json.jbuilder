json.array!(@sites) do |site|
  json.extract! site, :id, :url, :html
  json.url site_url(site, format: :json)
end
