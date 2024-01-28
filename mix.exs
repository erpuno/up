defmodule UP.Mixfile do
  use Mix.Project

  def project do
    [ app: :up,
      version: "1.0.0",
      elixir: ">= 1.12.0",
      description: "UP Uptime/Status Incidents and Maintenance Management.",
      deps: deps(),
      package: package(),
    ]
  end

  def package do
    [ files: ["lib", "include", "mix.exs", "README.md", "LICENSE"],
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
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end

end
