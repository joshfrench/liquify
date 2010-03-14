require File.dirname(__FILE__) + '/../spec_helper'

describe "Standard Tags" do
  dataset :users_and_pages, :file_not_found, :snippets
  
  it "should should allow access to current page" do
    pages(:home).should render('{% title %}').as('Home')
  end

  [:breadcrumb, :slug, :title, :url].each do |attr|
    it "{% #{attr} %} should render the '#{attr}' attribute" do
      page = pages(:home)
      value = page.send(attr)
      page.should render("{% #{attr} %}").as(value.to_s)
    end
  end

  it "{% url %} with a nil relative URL root should scope to the relative root of /" do
    ActionController::Base.relative_url_root = nil
    pages(:home).should render("{% url %}").as("/")
  end

  it '{% url %} with a relative URL root should scope to the relative root' do
    pages(:home).should render("{% url %}").with_relative_root("/foo").as("/foo/")
  end

  it '{% parent %} should change the local context to the parent page' do
    pages(:parent).should render('{% parent %}{% title %}{% endparent %}').as(pages(:home).title)
  end

  it "{% page.children %} should iterate over current page's children" do
    pages(:home).should render('{% for page in page.children %}{% title %}{% endfor %}').as(pages(:home).children.map(&:title).join(''))
  end

  it "{% children %} should respect scope of {% parent %}" do
    pages(:parent).should \
      render("{% parent %}{% for page in page.children %}{% title %}{% endfor %}{% endparent %}").
      as(pages(:home).children.collect(&:title).join(""))
  end

  it "{% parent %} should respect scope of {% children %}" do
    pages(:parent).should \
      render('{% for page in page.children %}{% parent %}{% title %}{% endparent %}{% endfor %}').
      as(pages(:parent).title * pages(:parent).children.count)
  end

end