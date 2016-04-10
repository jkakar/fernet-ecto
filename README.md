# Fernet.Ecto

`Fernet.Ecto` defines `Ecto.Type`-based fields that automatically
Fernet-encrypts and decrypts values stored and loaded from a repository.  The
[API documentation](http://hexdocs.pm/fernet_ecto/Fernet.Ecto.html) has more
details.

## Installation

1. Add [`fernet_ecto`](http://hex.pm/packages/fernet_ecto) to your list of
   dependencies in `mix.exs`:

   ```elixir
   def deps do
     [{:fernet_ecto, "~> 0.1.0"}]
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
* Run `git tag v$VERSION` to tag the version that was just published.
* Run `git push --tags origin master` to push tags to Github.
* Run `mix hex.publish` to publish the new version.
* Run `mix hex.docs` to publish the documentation.

## License

&copy; 2016 Jamshed Kakar <jkakar@kakar.ca>. See `LICENSE.md` file for
details.
