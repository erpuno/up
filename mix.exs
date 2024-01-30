defmodule UP.Mixfile do
  use Mix.Project

  def project do
    [ app: :up,
      version: "1.0.1",
      elixir: ">= 1.12.0",
      description: "UP Uptime/Status Incidents and Maintenance",
      deps: deps(),
      package: package(),
    ]
  end

  def package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Namdak Tonpa"],
      licenses: ["ISC"],
      links: %{"GitHub" => "https://github.com/erpuno/up"}
    ]
  end

  def application do
    [ extra_applications: [:logger, :plug_cowboy, :jason],
      mod: {UP.Application,[]}
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.21", only: :dev},
      {:nitro, "~> 7.10.0"},
      {:kvs, "~> 10.8.2"},
      {:syn, "2.1.0"},
      {:n2o, "~> 10.12.3"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end

end
