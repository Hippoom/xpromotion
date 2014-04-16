module XPromotion
  module Domain
    class Promotion
      include AggregateRoot
      include EventHandling::Dsl

      on XPromotion::Events::PromotionRegisteredEvent do |event|
        @id = event.id
      end

      on XPromotion::Events::PromotionApprovedEvent do |event|
        @status = 'APPROVED'
      end

      on XPromotion::Events::PromotionDisabledEvent do |event|
        @status = 'DISABLED'
      end

      attr_reader :id

      def self.register command
        create_from XPromotion::Events::PromotionRegisteredEvent.new(command.id)
      end

      def approved?
        @status == 'APPROVED'
      end

      def disabled?
        @status == 'DISABLED'
      end

    end

    class PromotionRepository
      include Repository

      self.aggregate_root= XPromotion::Domain::Promotion

    end
  end
end
