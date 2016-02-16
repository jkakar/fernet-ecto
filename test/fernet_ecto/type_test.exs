defmodule Fernet.Ecto.TypeTest do
  use ExUnit.Case

  setup do
    Application.ensure_all_started(:fernet_ecto)
  end

  test "Fernet.Ecto.Type.encrypt uses the fernet secret defined in the configuration to encrypt plaintext into ciphertext while Fernet.Ecto.Type.decrypt does the opposite" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    assert ciphertext != "plaintext"
    {:ok, plaintext} = Fernet.Ecto.Type.decrypt(ciphertext)
    assert plaintext == "plaintext"
  end
end
