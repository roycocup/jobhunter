
defmodule Jobhunter do

	alias Jobhunter.Cache

	def run(address) do
		data =
		case Cache.cache_exists?(hash(address)) do
			{:ok, _} -> use_data(address)
			{:error, _} -> fetch_and_cache_data(address)
		end
		|> Tuple.to_list
		# Map.to_list(data)
	end

	def use_data(address) do
		{_, string} = Cache.get_cached(hash(address))
		string
		|> String.to_charlist()
		|> Poison.decode(keys: :atoms)
	end

	def fetch_and_cache_data(address) do
		address
		|> sanitize_query()
		|> google()
		|> get_body()
		|> Cache.write_cache(hash(address))
	end

	def hash(hashable) do
		:crypto.hash(:sha, hashable)
		|> Base.encode16()
	end

	def google(query) do
		api_key = Application.get_env(:jobhunter, :google_api_key)
		google_cx_key = Application.get_env(:jobhunter, :google_cx_key)
		get("https://www.googleapis.com/customsearch/v1?key=#{api_key}&cx=#{google_cx_key}&q=#{query}")
	end

	def sanitize_query(query) do
		query
		|> String.trim()
		|> String.replace(" ", "%20")
	end

	def get(url) do
		HTTPotion.get url
	end

	def get_header(response) do
		response.headers
	end

	def get_body(response) do
		response.body
	end




end
