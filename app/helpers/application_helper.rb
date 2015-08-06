module ApplicationHelper
  def controller_action
    controller.controller_name + '#' + controller.action_name
  end
end
