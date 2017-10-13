defmodule Jobhunter.Cache do
	
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

  def cache_exists?(name) do
    File.stat(cache_folder_path() <> "/#{name}.json")
  end

  def get_cached(name) do
    File.read cache_folder_path() <> "/#{name}.json"
  end
end