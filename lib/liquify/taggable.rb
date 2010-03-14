module Liquify::Taggable
  def tag(name, &block)
    tag = Class.new(Liquid::Tag) do
      define_method :render, &block
    end
    Liquid::Template.register_tag name, tag
    tag
  end

  def block(name, &block)
    block = Class.new(Liquid::Block) do
      define_method :render, &block
    end
    Liquid::Template.register_tag name, block
    block
  end
end