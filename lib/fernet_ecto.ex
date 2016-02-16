defmodule Fernet.Ecto do
  @moduledoc """
  `Fernet.Ecto` provides
  [Fernet](https://github.com/kennyp/fernetex)-encrypted fields for Ecto.

  ## Defining a Fernet-encrypted field

  A Fernet-encrypted field can be defined on a schema just like any other Ecto
  field:

      defmodule Person do
        use Ecto.Schema

        schema "person" do
          field :name,         :string
          field :secret,       Fernet.Ecto.String
          field :more_secrets, Fernet.Ecto.Map
        end
      end

  ## Configuring secret and TTL values

  `Fernet.Ecto` types fetch the secret and TTL values used when Fernet
  encrypting and decrypting values from the application environment.  The most
  basic configuration is a single secret defined in `config.exs`:

      config :fernet_ecto, secret: "lyvBTUSkoEICefeuGZtAsILhZ25qotIqdHS5C1n6qDw="

  A TTL (in seconds) can also be defined.  The TTL is used in the decryption
  verification phase to ensure that the loaded data wasn't encrypted too far
  in the past:

      config :fernet_ecto, ttl: 3600

  ## Credential rotation

  Multiple secrets can be defined using a list:

      config :fernet_ecto, secret: ["HJ6dYDfyNmIRAjWLMUj_3zS8W9XkfWiln8DzpkxWACE=",
                                    "lyvBTUSkoEICefeuGZtAsILhZ25qotIqdHS5C1n6qDw="]

  The first available secret is always used when encrypting values to store in
  the database.  When values are loaded from the database the available
  secrets will be tried, in order, to decrypt and verify the data.  A
  `RuntimeError` is raised if none of the available secrets can be used to
  decrypt and verify the loaded data.

  The secret can be rotated by first adding a new secret and then loading
  every encrypted value from the database to decode it using the old key, and
  then writing it back to the database to encode it using the new key.  Once
  this procedure has been complete the old key can be removed from the
  configuration.
  """
end
