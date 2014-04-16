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
  end
end