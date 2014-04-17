require 'cqrs/command_handling'

module XPromotion
  module Commands
    class RegisterPromotionCommand
      attr_reader :id
      def initialize id
        @id = id
      end

      def ==(o)
        o.class == self.class && o.id == @id
      end

      def hash
        @id.hash
      end
    end

    class ApprovePromotionCommand
      include CommandHandling::Dsl

      identity :id
      def initialize id
        @id = id
      end

      def ==(o)
        o.class == self.class && o.id == @id
      end

      def hash
        @id.hash
      end

    end

    class DisablePromotionCommand
      include CommandHandling::Dsl

      identity :id
      def initialize id
        @id = id
      end

      def ==(o)
        o.class == self.class && o.id == @id
      end

      def hash
        @id.hash
      end

    end
  end
end