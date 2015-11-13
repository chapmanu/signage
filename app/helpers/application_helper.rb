module ApplicationHelper
  def controller_action
    controller.controller_name + '#' + controller.action_name
  end

  def format_date(date)
    date.strftime('%e %B, %Y') if date
  end

  def signs_controller?
    controller.controller_name == 'signs'
  end

  def slides_controller?
    controller.controller_name == 'slides'
  end

  def filter_pill_link(text, value)
    classes = params['filter'] == value ? 'active' : ''
    link_to(text, "?filter=#{value}", class: classes, data: { value: value })
  end

  def happy_button(text, href)
    link_to(href, class: 'happy-button') do
      "#{text} &nbsp;".html_safe + inline_svg('smiley.svg')
    end
  end
end
