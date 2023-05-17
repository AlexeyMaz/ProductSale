class ListStateNotifier
  attr_reader :list

  def initialize
    @list = []
    @listeners = []
  end

  def set_all(objects)
    @list = objects
    notify_listeners
  end

  def add(object)
    @list << object
    notify_listeners
  end

  def delete(object)
    @list.delete(object)
    notify_listeners
  end

  def replace(object, new_object)
    index = @list.index(object)
    @list[index] = new_object
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
      listener.update(self)
    end
  end
end
