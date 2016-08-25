class StreamingRepositoryServer < Streaming::Repository::Service
  def initialize(repository)
    @repository = repository
  end

  # rpc store (stream Item) returns (StoreReply) {}
  def store(call)
    num_stored_items = 0
    call.each_remote_read do |item|
      puts "[StreamingRepositoryServer] store : Request : #{item.inspect}"
      @repository[item.uuid] = item
      num_stored_items += 1
      break if num_stored_items == 10
    end

    Streaming::StoreReply.new(message: "Stored #{num_stored_items} items.").tap do |store_reply|
      puts "[StreamingRepositoryServer] store : Response : #{store_reply.inspect}"
    end
  end

  # rpc fetch (FetchRequest) returns (stream Item) {}
  def fetch(fetch_req, _call)
      puts "[StreamingRepositoryServer] fetch : Request : #{fetch_req.inspect}"
      DelayedItemEnum.new(@repository, fetch_req.num_items).each
  end

  def store_and_fetch(items, _call)
  end

  class DelayedItemEnum
    def initialize(repository, num_items)
      @items = repository.values.slice(0..(num_items - 1))
      @num_items = num_items
    end

    def each
      return enum_for(:each) unless block_given?
      random = Random.new
      @items.each do |item|
        sleep(random.rand(1..10))
        puts "[StreamingRepositoryServer] fetch : Response : #{item.inspect}"
        yield item
      end
    end
  end
end
