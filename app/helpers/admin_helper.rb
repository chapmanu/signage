module AdminHelper
  def home_button
    link_to "<< Home", admin_path, class: 'home-button'
  end

  def display_flashes
    ap 'Whaaaat up!?!'
    html = ''.html_safe
    ap flash.inspect
    flash.each do |type, message|
      # We have styles for when type = 'success', 'error', 'notice', and 'alert'
      html += content_tag :div, class: "flash-#{type}" do
        content_tag :span, message
      end
    end
    html
  end
end
