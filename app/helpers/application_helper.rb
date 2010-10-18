module ApplicationHelper
  include Acl9Helpers
  def format(str)
    bc = BlueCloth.new(str)
    bc.to_html
  end

end

# Custom tab builder made to work with yaml
class MenuTabBuilder < TabsOnRails::Tabs::Builder
  def tab_for(tab, name, options, item_options = {})
    item_options[:class] = item_options[:class].to_s.split(" ").push("active").join(" ") if current_tab?(tab)
    content = @context.link_to_unless(current_tab?(tab), name, options) do
      @context.content_tag(:strong, name)
    end
    @context.content_tag(:li, content, item_options)
  end
  def close_tabs(options = {})
    "</ul>".try(:html_safe)
  end

  def open_tabs(options = {})
    @context.tag("ul", options, open = true)
  end
end

module ActiveRecord
  class Base  
    def self.to_select(index={}, conditions=nil)
      find(:all, :conditions => conditions).to_select(index)
    end
  end
end

class Array
  def to_select(index)
    self.collect { |x| [x.const_get(index),x.id] }
  end
  def to_select_title
    self.collect { |x| [x.title, x.id] }
  end
end
