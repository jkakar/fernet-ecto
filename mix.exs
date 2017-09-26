defmodule Fernet.Ecto.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [app: :fernet_ecto,
     description: "Fernet-encrypted fields for Ecto",
     package: package(),
     version: @version,
     name: "fernet-ecto",
     homepage_url: "https://github.com/jkakar/fernet-ecto",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [source_ref: "v#{@version}", main: "Fernet.Ecto",
            source_url: "https://github.com/jkakar/fernet-ecto"],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:ecto,
                    :fernetex,
                    :logger]]
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
    [{:earmark, "~> 1.1", only: [:dev]},
     {:ex_doc, "~> 0.15.0", only: [:dev]},
     {:ecto, "~> 2.2.0"},
     {:fernetex, "~> 0.3.0"}]
  end

  defp package do
    [maintainers: ["Jamu Kakar"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/jkakar/fernet-ecto",
              "Docs" => "http://hexdocs.pm/fernet_ecto/#{@version}/"}]
  end
end
