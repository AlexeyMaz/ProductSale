class ListStateNotifier
  attr_reader :list

  def initialize
    @items = []
    @listeners = []
  end

  def set_all(objects)
    @items = objects
    notify_listeners
  end

  def add(object)
    @items << object
    notify_listeners
  end

  def delete(object)
    @items.delete(object)
    notify_listeners
  end

  def replace(object, new_object)
    index = @items.index(object)
    @items[index] = new_object
    notify_listeners
  end

  def add_listener(listener)
    @listeners << listener
  end

  def delete_listener(listener)
    @listeners.delete(listener)
  end

  def notify_listeners
    @listeners.each do |listener|
      puts @items
      listener.update(@items)
    end
  end
end
