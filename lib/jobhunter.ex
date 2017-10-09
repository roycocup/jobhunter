defmodule Jobhunter do
  @@doc """
  
  to play with this you mush run

  Jobhunter.run "new bond street london"


  """

  def run(address) do
    case cache_exists(hash(address)) do
        {:error, _} -> grab_data(address)
        {:ok, _} -> "This query has already been cached. Do something with it now"
    end
  end

  def grab_data(address) do
    address
    |> sanitize_query
    |> google
    |> get_body
    |> write_cache(hash(address))
  end

  def hash(hashable) do
    :crypto.hash(:sha, hashable)
    |> Base.encode16
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

  def create_cache_folder do
    cache_folder_path()    
    |> File.mkdir!();
  end

  def cache_folder_path do
    "./cache"
  end

  def write_cache(content, name) do
    
    # create cache folder if not exists
    case File.stat(cache_folder_path()) do
      {:ok, _} -> :ok
      _ -> create_cache_folder()
    end
    
    {:ok, pid} = File.open cache_folder_path() <> "/#{name}.json", [:write, :utf8]
    IO.binwrite pid, content
    File.close pid
  end

  def cache_exists(name) do
    File.stat(cache_folder_path() <> "/#{name}.json")
  end


end
