require "openssl/cipher"
require "base64"

# require "io"

class Encrypter
  @@key = Base64.decode(File.read("/home/bmaxwell/keys/key"))
  # @@iv = File.read("/home/bmaxwell/keys/iv")

  @@cipher = OpenSSL::Cipher.new("AES-256-CBC")
  @@cipher.encrypt
  @@cipher.key = @@key

  @@decipher = OpenSSL::Cipher.new("AES-256-CBC")
  @@decipher.decrypt
  @@decipher.key = @@key

  # @@decipher.iv = @@iv

  def self.encrypt(input)
    @@cipher.reset
    io = IO::Memory.new
    io.set_encoding("ASCII-8BIT")
    io.write(@@cipher.update(input))
    io.write(@@cipher.final)
    io.to_slice
  end

  def self.decrypt(input)
    @@decipher.reset
    io = IO::Memory.new
    io.set_encoding("ASCII-8BIT")
    io.write(@@decipher.update(input))
    io.write(@@decipher.final)
    io.to_s.encode("UTF-8")
  end
end
