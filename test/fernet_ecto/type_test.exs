defmodule Fernet.Ecto.TypeTest do
  use ExUnit.Case, async: false

  @secret "20ZD73BpaKahI3lBAq6qYoEzNVG5dSA56wHTNatlVsY="

  setup do
    Application.ensure_all_started(:fernet_ecto)

    # Reset the application environment between tests.
    default_secret = Application.get_env(:fernet_ecto, :secret)
    default_ttl = Application.get_env(:fernet_ecto, :ttl)
    on_exit fn ->
      Application.put_env(:fernet_ecto, :secret, default_secret)
      Application.put_env(:fernet_ecto, :ttl, default_ttl)
    end
  end

  test "Fernet.Ecto.Type.encrypt uses the fernet secret defined in the configuration to encrypt plaintext into ciphertext while Fernet.Ecto.Type.decrypt does the opposite" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    assert ciphertext != "plaintext"
    {:ok, plaintext} = Fernet.Ecto.Type.decrypt(ciphertext)
    assert plaintext == "plaintext"
  end

  test "Fernet.Ecto.Type.encrypt uses the first secret in a list of secrets to encrypt values" do
    old_secret = Application.get_env(:fernet_ecto, :secret)
    Application.put_env(:fernet_ecto, :secret, [@secret, old_secret])
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    {:ok, "plaintext"} = Fernet.verify(token: ciphertext, secret: @secret)
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.verify(token: ciphertext, secret: old_secret)
    end
  end

  test "Fernet.Ecto.Type.decrypt falls back to older secrets when the earlier ones aren't valid" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    old_secret = Application.get_env(:fernet_ecto, :secret)
    Application.put_env(:fernet_ecto, :secret, [@secret, old_secret])
    {:ok, "plaintext"} = Fernet.Ecto.Type.decrypt(ciphertext)
  end

  test "Fernet.Ecto.Type.decrypt raises an exception if no available secret is able to decrypt the ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    Application.put_env(:fernet_ecto, :secret, @secret)
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.Ecto.Type.decrypt(ciphertext)
    end
  end

  test "Fernet.Ecto.Type.decrypt raises an exception if none of the available secrets are able to decrypt the ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    Application.put_env(:fernet_ecto, :secret, [@secret])
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.Ecto.Type.decrypt(ciphertext)
    end
  end
end
