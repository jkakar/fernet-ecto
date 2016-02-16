defmodule Fernet.Ecto.StringTest do
  use ExUnit.Case

  setup do
    Application.ensure_all_started(:fernet_ecto)
  end

  test "Fernet.Ecto.String.type is always :binary" do
    assert Fernet.Ecto.String.type == :binary
  end

  test "Fernet.Ecto.String.cast ensures that only binary and string values are accepted" do
    assert Fernet.Ecto.String.cast("plaintext") == "plaintext"
    assert Fernet.Ecto.String.cast(<<"plaintext">>) == <<"plaintext">>
    assert Fernet.Ecto.String.cast(:atom) == :error
    assert Fernet.Ecto.String.cast(1) == :error
    assert Fernet.Ecto.String.cast(1.0) == :error
    assert Fernet.Ecto.String.cast([:list]) == :error
    assert Fernet.Ecto.String.cast(%{key: :value}) == :error
  end

  test "Fernet.Ecto.String.dump encrypts plaintext and Fernet.Ecto.String.load decrypts ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.String.dump("plaintext")
    assert ciphertext != "plaintext"
    {:ok, plaintext} = Fernet.Ecto.String.load(ciphertext)
    assert plaintext == "plaintext"
  end
end
