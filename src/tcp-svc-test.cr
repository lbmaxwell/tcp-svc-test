require "./tcp-svc-test/*"
require "socket"
require "base64"
require "openssl/cipher"

# TODO: Write documentation for `Tcp::Svc::Test`
module Tcp::Svc::Test
  # TODO: Make port a command line argument
  port = 7000

  def self.handle_client(client)
    raw_message = client.gets

    if raw_message.is_a?(String)
      message = Base64.decode(raw_message)
      puts Encrypter.decrypt(message)
    else
      puts ""
    end

    # Need to write handler here
    response = "Hello from server!"
    response = Encrypter.encrypt(response)
    response = Base64.encode(response)

    client.print(response)
    client.close
  end

  puts "Listinging on port #{port}..."

  server = TCPServer.new("127.0.0.1", port, 100, nil, true)
  loop {
    if socket = server.accept?
      # handle the client in a fiber
      spawn handle_client(socket)
    else
      # another fiber closed the server
      break
    end
  }
end
