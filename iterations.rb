require 'rubygems'
require 'liquid'

class Thing
  attr_accessor :children, :name
  liquid_methods :children, :name
  def initialize(name)
    @name = name
  end
end

@thing = Thing.new('chuck')
@thing.children = [Thing.new('vera'), Thing.new('Dave')]

class NameTag < Liquid::Tag
  def render(context)
    context['thing'].name
  end
end
Liquid::Template.register_tag('name', NameTag)

class EachChildTag < Liquid::Block
  def render(context)
    result = []
    context['thing'].children.each do |child|
      context.stack do
        context['thing'] = child
        result << super
      end
    end
    result.join
  end
end
Liquid::Template.register_tag('each_child', EachChildTag)

t = Liquid::Template.parse(DATA.read)
puts t.render('thing' => @thing)

__END__
{% name %}
{% for i in thing.children %}
  {{ i.name }}
{% endfor %}

{% each_child %}
  {% name %}
{% endeach_child %}