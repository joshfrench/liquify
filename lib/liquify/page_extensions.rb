module Liquify
  module PageExtensions
    def self.included(base)
      base.class_eval do
        def to_liquid
          Liquify::PageDrop.new(self)
        end
        named_scope :physical, :conditions => { :virtual => false }
        Status.find_all.each do |status|
          named_scope status.name.underscore, :conditions => { :status_id => status.id }
        end
      end
    end
  end
end