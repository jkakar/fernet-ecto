defmodule Fernet.Ecto.Type do
  @moduledoc false

  def encrypt(plaintext) do
    encrypt(plaintext, secret)
  end

  defp encrypt(plaintext, secret) when is_binary(secret) do
    {:ok, _iv, ciphertext} = Fernet.generate(message: plaintext,
                                             secret: secret)
    {:ok, ciphertext}
  end

  defp encrypt(plaintext, secrets) when is_list(secrets) do
    [secret|_] = secrets
    {:ok, _iv, ciphertext} = Fernet.generate(message: plaintext,
                                             secret: secret)
    {:ok, ciphertext}
  end

  def decrypt(ciphertext) do
    decrypt(ciphertext, secret)
  end

  defp decrypt(ciphertext, secret) when is_binary(secret) do
    Fernet.verify(token: ciphertext,
                  secret: secret,
                  enforce_ttl: enforce_ttl,
                  ttl: ttl)
  end

  defp decrypt(_ciphertext, []) do
    raise "incorrect mac"
  end

  defp decrypt(ciphertext, secrets) when is_list(secrets) do
    [secret|rest] = secrets
    try do
      Fernet.verify(token: ciphertext,
                    secret: secret,
                    enforce_ttl: enforce_ttl,
                    ttl: ttl)
    rescue
      RuntimeError -> decrypt(ciphertext, rest)
    end
  end

  defp secret do
    Application.fetch_env!(:fernet_ecto, :secret)
  end

  defp enforce_ttl do
    case ttl do
      nil -> false
      _ -> true
    end
  end

  defp ttl do
    Application.get_env(:fernet_ecto, :ttl)
  end
end
