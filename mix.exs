defmodule Momento.Mixfile do
  use Mix.Project

  def project do
    [
      app: :momento,
      version: "0.2.0",
      description: description(),
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      source_url: "https://github.com/oviceinc/momento",
      homepage_url: "https://github.com/oviceinc/momento"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:excoveralls, "~> 0.16.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Momento is an Elixir port of Moment.js for the purpose of parsing, validating, manipulating, and formatting dates.
    """
  end

  defp package do
    [
      name: :momento,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["oVice Developers"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/oviceinc/momento"}
    ]
  end
end
