class Liquify::Tags
  extend Liquify::Taggable

  # tag 'snippet' do |context|
  #   source  = Liquid::Template.file_system.read_template_file(@markup, Snippet)
  #   partial = Liquid::Template.parse(source)
  #   partial.render(context)
  # end.class_eval do
  #   attr_accessor :snippet
  #   def initialize(tag_name, markup, tokens)
  #     super
  #     @markup.strip!
  #   end
  # end

  class SnippetTag < Liquid::Tag
    attr_accessor :snippet

    def initialize(tag_name, markup, tokens)
      super
      @markup.strip!
    end

    def render(context)
      source  = Liquid::Template.file_system.read_template_file(@markup, Snippet)
      partial = Liquid::Template.parse(source)
      partial.render(context)
    end

  end
  Liquid::Template.register_tag('snippet', SnippetTag)
  
  class CurrentTimeTag < Liquid::Tag
    def render(context)
      if @markup.empty?
        Time.now
      else
        Time.now.strftime(@markup.strip)
      end
    end
  end
  Liquid::Template.register_tag('current_time', CurrentTimeTag)
  
  tag 'title' do |context|
    context['page'].title
  end
  
  tag 'breadcrumb' do |context|
    context['page'].breadcrumb
  end

  tag 'slug' do |context|
    context['page'].slug
  end

  # context.registers[:request]
  url = tag 'url' do |context|
    context['page'].url
  end

  block 'parent' do |context|
    context.stack do
      context['page'] = context['page'].parent
      render_all(@nodelist, context)
    end
  end

  # block 'children' do |context|
  #   context['page'].children
  # end

end