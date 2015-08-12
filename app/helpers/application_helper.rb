module ApplicationHelper
  def controller_action
    controller.controller_name + '#' + controller.action_name
  end

  def format_date(date)
    date.strftime('%B %d, %Y %l:%M %P')
  end
end
