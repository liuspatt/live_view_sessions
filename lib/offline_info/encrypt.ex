defmodule Encrypt do
  @moduledoc """
  Provides functions for AES 256-bit encryption and decryption.
  """

  # Generates a 32-byte key from a passphrase. Replace "your_secret_passphrase" with your actual passphrase.
  @key :crypto.hash(:sha256, "your_secret_passphrase")
  @iv_length 16

  @doc """
  Encrypts plaintext using AES 256-bit encryption.

  ## Parameters:
  - plaintext: The data to encrypt.

  ## Returns:
  - A base64-encoded string containing the IV and the ciphertext.
  """
  def encrypt(plaintext) do
    iv = :crypto.strong_rand_bytes(@iv_length)
    cipher = :crypto.crypto_one_time(:aes_256_cbc, @key, iv, plaintext, true)
    Base.encode64(iv <> cipher)
  end

  @doc """
  Decrypts a base64-encoded ciphertext using AES 256-bit encryption.

  ## Parameters:
  - encoded: The base64-encoded IV and ciphertext.

  ## Returns:
  - The decrypted plaintext.
  """
  def decrypt(encoded) do
    {iv, cipher} = encoded |> Base.decode64!() |> split_iv_and_cipher()
    :crypto.crypto_one_time(:aes_256_cbc, @key, iv, cipher, false)
  end

  defp split_iv_and_cipher(data) do
    iv = binary_part(data, 0, @iv_length)
    cipher = binary_part(data, @iv_length, byte_size(data) - @iv_length)
    {iv, cipher}
  end
end
