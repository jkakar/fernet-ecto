# Fernet.Ecto

`Fernet.Ecto` defines `Ecto.Type`s that automatically Fernet-encrypt and
decrypt values store and loaded from a repository.

## Installation

1. Add `fernet_ecto` to your list of dependencies in `mix.exs`:

   ```elixir
   def deps do
     [{:fernet_ecto, "~> 0.0.1"}]
   end
   ```

1. Run `mix deps.get` to fetch and install the package.

1. Ensure `fernet_ecto` is started before your application:

   ```elixir
   def application do
     [applications: [:fernet_ecto]]
   end
   ```

## Release

* Bump the version here in the `README.md` and in `mix.exs`.
* Run `git tag $VERSION` to tag the version that was just published.
* Run `git push --tags origin master` to push tags to Github.
* Run `mix hex.publish` to publish the new version.
* Run `mix hex.docs` to publish the documentation.

## License

&copy; 2016 Jamshed Kakar <jkakar@kakar.ca>. See `LICENSE.md` file for
details.
