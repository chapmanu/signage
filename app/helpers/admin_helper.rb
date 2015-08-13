module AdminHelper
  def home_button
    link_to "<< Home", admin_path, class: 'home-button'
  end

  def display_flashes
    html = ''.html_safe
    flash.each do |type, message|
      # We have styles for when type = 'success', 'error', 'notice', and 'alert'
      html += content_tag :div, class: "flash-#{type}" do
        content_tag :span, message
      end
    end
    html
  end

  def search_form(path)
    form_tag path, class: 'search-bar', role: 'search', method: 'get' do
      html =  ''.html_safe
      html += search_field_tag :search, params[:search], placeholder: 'Enter Search'
      html += button_tag(name: nil) { image_tag('search-icon.png', alt: 'Search Icon') }
    end
  end
end
