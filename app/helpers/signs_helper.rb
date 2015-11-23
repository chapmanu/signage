module SignsHelper

  def sign_name_with_approval_details(sign)
    if sign.owned_by?(current_user)
      sign.name
    else
      "#{sign.name} <strong>(requires approval)</strong>".html_safe
    end
  end
end
