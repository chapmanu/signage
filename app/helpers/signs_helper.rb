module SignsHelper

  def sign_name_with_approval_details(sign)
    if sign.owned_by?(current_user)
      "#{sign.name} <strong>(requires approval)</strong>".html_safe
    else
      sign.name
    end
  end
end
