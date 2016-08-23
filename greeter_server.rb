class GreeterServer < Helloworld::Greeter::Service
  def say_hello(hello_req, _unused_call)
    puts "[GreeterServer] Request: #{hello_req.inspect}"
    Helloworld::HelloReply.new(message: "Hello #{hello_req.name}").tap do |hello_res|
      puts "[GreeterServer] Response: #{hello_res.inspect}"
    end
  end
end
