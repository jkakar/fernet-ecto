defmodule Fernet.Ecto do
  @moduledoc """
  [Fernet](https://github.com/kennyp/fernetex)-encrypted fields for Ecto.

  ## Defining a Fernet-encrypted field

  A Fernet-encrypted field can be defined on a schema just like any other Ecto
  field:

      defmodule MyApp.User do
        use Ecto.Schema

        schema "users" do
          field :name,         :string
          field :secret,       Fernet.Ecto.String
          field :more_secrets, Fernet.Ecto.Map
        end
      end

  Both `Fernet.Ecto.String` and `Fernet.Ecto.Map` are stored in `:binary`
  columns in the database:

      defmodule MyApp.Repo.Migrations.CreateUsers do
        use Ecto.Migration

        def up do
          create table(:users) do
            add :name,         :text
            add :secret,       :binary
            add :more_secrets, :binary
          end
        end

        def down do
          drop table(:users)
        end
      end

  ## Configuring key and TTL values

  `Fernet.Ecto` types fetch the key and TTL values used when Fernet encrypting
  and decrypting values from the application environment.  The most basic
  configuration is a single key defined in `config.exs`:

      config :fernet_ecto, key: "lyvBTUSkoEICefeuGZtAsILhZ25qotIqdHS5C1n6qDw="

  A TTL (in seconds) can also be defined.  The TTL is used in the decryption
  verification phase to ensure that the loaded data wasn't encrypted too far
  in the past:

      config :fernet_ecto, ttl: 3600

  ## Credential rotation

  Multiple keys can be defined using a list:

      config :fernet_ecto, key: ["HJ6dYDfyNmIRAjWLMUj_3zS8W9XkfWiln8DzpkxWACE=",
                                 "lyvBTUSkoEICefeuGZtAsILhZ25qotIqdHS5C1n6qDw="]

  The first available key is always used when encrypting values to store in
  the database.  When values are loaded from the database the available keys
  will be tried in order to decrypt and verify the data.  A `RuntimeError` is
  raised if none of the available keys can be used to decrypt and verify the
  loaded data.

  The key can be rotated by first adding a new key and then loading every
  encrypted value from the database to decode it using the old key, and then
  writing it back to the database to encode it using the new key.  Once this
  procedure has been completed the old key can be removed from the
  configuration.
  """
end
