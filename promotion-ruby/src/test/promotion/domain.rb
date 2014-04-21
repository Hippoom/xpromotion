require 'cqrs/event_sourcing'
require 'cqrs/command_handling'

module XPromotion
  module Domain
    class Promotion
      include EventSourcedAggregateRoot
      include CommandHandling::AnonymousAggregateRootCommandHandler

      on XPromotion::Events::PromotionRegisteredEvent do |event|
        @id = event.id
      end

      on XPromotion::Events::PromotionApprovedEvent do |event|
        @status = 'APPROVED'
      end

      on XPromotion::Events::PromotionDisabledEvent do |event|
        @status = 'DISABLED'
      end

      from XPromotion::Commands::RegisterPromotionCommand do |command|
        apply XPromotion::Events::PromotionRegisteredEvent.new(command.id)
      end

      handle XPromotion::Commands::ApprovePromotionCommand do |command|
        apply XPromotion::Events::PromotionApprovedEvent.new(@id)
      end

      handle XPromotion::Commands::DisablePromotionCommand do |command|
        apply XPromotion::Events::PromotionDisabledEvent.new(@id)
      end

      #identity :id

      def approved?
        @status == 'APPROVED'
      end

      def disabled?
        @status == 'DISABLED'
      end

    end

  end
end
