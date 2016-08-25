class StreamingRepositoryServer < Streaming::Repository::Service
  def initialize
    @repository = {}
  end

  # rpc store (stream Item) returns (StoreReply) {}
  def store(call)
    num_stored_items = 0
    call.each_remote_read do |item|
      puts "[StreamingRepositoryServer] store : Request : #{item.inspect}"
      @repository[item.uuid] = item
      num_stored_items += 1
    end

    Streaming::StoreReply.new(message: "stored #{num_stored_items} items.").tap do |store_reply|
      puts "[StreamingRepositoryServer] store : Response : #{store_reply.inspect}"
    end
  end

  def fetch(fetch_req, _call)
  end

  def store_and_fetch(items, _call)
  end
end
