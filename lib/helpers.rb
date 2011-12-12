module OCG
  module Helpers
  extend self

      def instances
        OCG.instances
      end
      
      def servers
        OCG.servers
      end

      def products
        OCG.products
      end

      def params
        OCG.params
      end
      
      def filewriter
        OCG.filewriter
      end
  end
end
