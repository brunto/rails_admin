# https://github.com/dmfrancisco/activo
# http://dmfrancisco.github.com/activo/demo/activo.html
module RailsAdmin
  module ActivoHelper

    def activo_block(options={}, &block)
      concat(content_tag('div', capture(&block), :class => 'block'))
    end

    def activo_secondary_navigation(links, active_link=nil)
      lis = links.map do |link|
        css_classes = []
        css_classes << "first" if links.first == link
        css_classes << "active" if active_link == link
        content_tag(:li, link, :class => css_classes)
      end
      content_tag(:div, :class => "secondary-navigation") do
        content_tag(:ul, :class => "wat-cf") do
          lis.join("\n").html_safe
        end
      end
    end

    def activo_block_content(options={}, &block)
      concat(content_tag('div', capture(&block), :class => 'content'))
    end

    def activo_block_content_header(title, controls_links)
      content_tag('div', activo_block_controls(controls_links) + content_tag('h2', title, :class => 'title'), :class => 'content-header')
    end
    
    # TODO : filters
    def activo_block_controls(links)
      content_tag('div', links.join("\n").html_safe, :class => 'control')
    end

    def activo_block_inner_content(&block)
      concat(content_tag('div', capture(&block), :class => 'inner'))
    end

    def activo_table(&block)
      concat(content_tag('table', capture(&block), :class => 'table grid'))
    end

  end
end
