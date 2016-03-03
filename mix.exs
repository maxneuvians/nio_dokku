defmodule NioDokku.Mixfile do
  use Mix.Project

  def project do
    [app: :nio_dokku,
     version: "0.0.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :ssh]]
  end

  defp deps do
    [
      {:mock, "~> 0.1.1", only: :test},
      {:sshex, "2.1.0"}
    ]
  end
end
