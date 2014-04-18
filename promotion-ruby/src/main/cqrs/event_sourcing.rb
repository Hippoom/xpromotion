require 'cqrs/domain'
require 'cqrs/event_handling'

module EventSourcedAggregateRoot
  
  def self.included(clazz)
    clazz.class_eval do
      include AggregateRoot
      include EventHandling::Dsl
    end
  end

end

