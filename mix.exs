defmodule Jobhunter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :jobhunter,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:json, "~> 1.0.2"},
      {:poison, "~> 3.1"},
      {:floki, "~> 0.18.0"},
    ]
  end
end
