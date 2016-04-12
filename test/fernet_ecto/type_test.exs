defmodule Fernet.Ecto.TypeTest do
  use ExUnit.Case, async: false

  @key "20ZD73BpaKahI3lBAq6qYoEzNVG5dSA56wHTNatlVsY="

  setup do
    Application.ensure_all_started(:fernet_ecto)

    # Reset the application environment between tests.
    default_key = Application.get_env(:fernet_ecto, :key)
    default_ttl = Application.get_env(:fernet_ecto, :ttl)
    on_exit fn ->
      Application.put_env(:fernet_ecto, :key, default_key)
      Application.put_env(:fernet_ecto, :ttl, default_ttl)
    end
  end

  test "Fernet.Ecto.Type.encrypt uses the fernet key defined in the configuration to encrypt plaintext into ciphertext while Fernet.Ecto.Type.decrypt does the opposite" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    assert ciphertext != "plaintext"
    {:ok, plaintext} = Fernet.Ecto.Type.decrypt(ciphertext)
    assert plaintext == "plaintext"
  end

  test "Fernet.Ecto.Type.encrypt uses the first key in a list of keys to encrypt values" do
    old_key = Application.get_env(:fernet_ecto, :key)
    Application.put_env(:fernet_ecto, :key, [@key, old_key])
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    {:ok, "plaintext"} = Fernet.verify(ciphertext, key: @key)
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.verify(ciphertext, key: old_key)
    end
  end

  test "Fernet.Ecto.Type.decrypt falls back to older keys when the earlier ones aren't valid" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    old_key = Application.get_env(:fernet_ecto, :key)
    Application.put_env(:fernet_ecto, :key, [@key, old_key])
    {:ok, "plaintext"} = Fernet.Ecto.Type.decrypt(ciphertext)
  end

  test "Fernet.Ecto.Type.decrypt raises an exception if no available key is able to decrypt the ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    Application.put_env(:fernet_ecto, :key, @key)
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.Ecto.Type.decrypt(ciphertext)
    end
  end

  test "Fernet.Ecto.Type.decrypt raises an exception if none of the available keys are able to decrypt the ciphertext" do
    {:ok, ciphertext} = Fernet.Ecto.Type.encrypt("plaintext")
    Application.put_env(:fernet_ecto, :key, [@key])
    assert_raise RuntimeError, "incorrect mac", fn ->
      Fernet.Ecto.Type.decrypt(ciphertext)
    end
  end
end
