module ApplicationHelper
  def controller_action
    controller.controller_name + '#' + controller.action_name
  end

  def format_date(date)
    date.strftime('%e %B, %Y') if date
  end

  def format_time(date)
    date.strftime('%l:%M %P') if date
  end

  def signs_controller?
    controller.controller_name == 'signs'
  end

  def slides_controller?
    controller.controller_name == 'slides'
  end

  def search_filter(key, text, value, options = {})
    classes = params[key] == value ? 'active' : ''
    link_to(text, "?#{key}=#{value}", class: classes, data: { value: value })
  end
end
