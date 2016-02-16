defmodule Fernet.Ecto.Type do
  def encrypt(plaintext) do
    {:ok, _iv, ciphertext} = Fernet.generate(message: plaintext,
                                             secret: secret)
    {:ok, ciphertext}
  end

  def decrypt(ciphertext) do
    Fernet.verify(token: ciphertext,
                  secret: secret,
                  enforce_ttl: enforce_ttl,
                  ttl: ttl)
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
