
require 'document_node'
module DocumentTree
  
  
  class << self
    attr_accessor :location
    def location
      @location || (defined?(Rails) ? File.join(Rails.root, 'app', 'docs') : 'docs')
    end

    
    def root
      @root ||= DocumentNode.new(self.location)
    end
  end

end

