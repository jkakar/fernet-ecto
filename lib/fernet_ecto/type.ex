defmodule Fernet.Ecto.Type do
  @moduledoc false

  def encrypt(plaintext) do
    encrypt(plaintext, key())
  end

  defp encrypt(plaintext, key) when is_binary(key) do
    {:ok, _iv, ciphertext} = Fernet.generate(plaintext, key: key)
    {:ok, ciphertext}
  end

  defp encrypt(plaintext, keys) when is_list(keys) do
    [key|_] = keys
    {:ok, _iv, ciphertext} = Fernet.generate(plaintext, key: key)
    {:ok, ciphertext}
  end

  def decrypt(ciphertext) do
    decrypt(ciphertext, key())
  end

  defp decrypt(ciphertext, key) when is_binary(key) do
    plaintext = Fernet.verify!(ciphertext, key: key, enforce_ttl: enforce_ttl(), ttl: ttl())
    {:ok, plaintext}
  end

  defp decrypt(_ciphertext, []) do
    raise "incorrect mac"
  end

  defp decrypt(ciphertext, keys) when is_list(keys) do
    [key|rest] = keys
    try do
      plaintext = Fernet.verify!(ciphertext, key: key, enforce_ttl: enforce_ttl(), ttl: ttl())
      {:ok, plaintext}
    rescue
      RuntimeError -> decrypt(ciphertext, rest)
    end
  end

  defp key do
    Application.fetch_env!(:fernet_ecto, :key)
  end

  defp enforce_ttl do
    case ttl() do
      nil -> false
      _ -> true
    end
  end

  defp ttl do
    Application.get_env(:fernet_ecto, :ttl)
  end
end
