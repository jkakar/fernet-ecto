defmodule Fernet.Ecto.MapTest do
  use ExUnit.Case

  setup do
    Application.ensure_all_started(:fernet_ecto)
  end

  test "Fernet.Ecto.Map.type is always :binary" do
    assert Fernet.Ecto.Map.type == :binary
  end

  test "Fernet.Ecto.Map.cast ensures that only map values are accepted" do
    assert Fernet.Ecto.Map.cast(%{key: :value}) == {:ok, %{key: :value}}
    assert Fernet.Ecto.Map.cast("plaintext") == :error
    assert Fernet.Ecto.Map.cast(<<"plaintext">>) == :error
    assert Fernet.Ecto.Map.cast(:atom) == :error
    assert Fernet.Ecto.Map.cast(1) == :error
    assert Fernet.Ecto.Map.cast(1.0) == :error
    assert Fernet.Ecto.Map.cast([:list]) == :error
  end

  test "Fernet.Ecto.Map.dump encrypts maps and Fernet.Ecto.Map.load decrypts ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.Map.dump(%{key: :value})
    assert ciphertext != %{key: :value}
    {:ok, map} = Fernet.Ecto.Map.load(ciphertext)
    assert map == %{key: :value}
  end
end
