defmodule Fernet.Ecto.TypeTest do
  use ExUnit.Case

  setup do
    Application.ensure_all_started(:fernet_ecto)
  end

  test "Fernet.Ecto.Type.encrypt uses the fernet secret defined in the configuration to encrypt plaintext into ciphertext while Fernet.Ecto.Type.decrypt does the opposite" do
    plaintext1 = "The quick brown fox jumped over the lazy dog"
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt(plaintext1)
    assert plaintext1 != ciphertext

    {:ok, plaintext2} = Fernet.Ecto.Type.decrypt(ciphertext)
    assert plaintext1 == plaintext2
  end
end
