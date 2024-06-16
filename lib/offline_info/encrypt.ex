defmodule Cipher do
  @block_size 16
  @secret_key :crypto.hash(:sha256, "load_some_key")

  @spec encrypt(String.t()) :: String.t()
  def encrypt(plain_text) do
    secret_key_hash = make_hash(@secret_key, 32)
    iv = :crypto.strong_rand_bytes(@block_size)
    padded_text = pad_pkcs7(plain_text, @block_size)
    encrypted_text = :crypto.crypto_one_time(:aes_256_cbc, secret_key_hash, iv, padded_text, true)
    encrypted_text = iv <> encrypted_text
    Base.encode64(encrypted_text)
  end

  @spec decrypt(String.t()) :: String.t()
  def decrypt(cipher_text) do
    secret_key_hash = make_hash(@secret_key, 32)
    {:ok, ciphertext} = Base.decode64(cipher_text)
    <<iv::binary-16, ciphertext::binary>> = ciphertext
    decrypted_text = :crypto.crypto_one_time(:aes_256_cbc, secret_key_hash, iv, ciphertext, false)
    unpad_pkcs7(decrypted_text)
  end

  @spec pad_pkcs7(String.t(), non_neg_integer()) :: String.t()
  def pad_pkcs7(message, blocksize) do
    pad = blocksize - rem(byte_size(message), blocksize)
    message <> to_string(List.duplicate(pad, pad))
  end

  @spec unpad_pkcs7(String.t()) :: binary()
  def unpad_pkcs7(data) do
    <<pad>> = binary_part(data, byte_size(data), -1)
    binary_part(data, 0, byte_size(data) - pad)
  end

  @spec make_hash(String.t(), non_neg_integer()) :: binary()
  defp make_hash(text, length) do
    :crypto.hash(:sha256, text)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
