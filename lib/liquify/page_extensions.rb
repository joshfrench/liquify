module Liquify
  module PageExtensions
    def self.included(base)
      base.class_eval do
        def to_liquid
          Liquify::PageDrop.new(self)
        end
      end
    end
  end
end