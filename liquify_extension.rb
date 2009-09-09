# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class LiquifyExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/liquify"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :liquify
  #   end
  # end
  
  def activate
    # admin.tabs.add "Liquify", "/admin/liquify", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Liquify"
  end
  
end
