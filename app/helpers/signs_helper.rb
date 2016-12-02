module SignsHelper

  def sign_name_with_approval_details(sign)
    if sign.owned_by?(current_user)
      sign.name
    else
      "#{sign.name} <strong>(requires approval)</strong>".html_safe
    end
  end

  def sign_status_orb(sign)
    orb_title = sign.hidden? ? 'Sign is hidden' : sign.active? ? 'Sign is live' : 'Sign is inactive'
    orb_class = sign.hidden? ? 'sign-hidden' : sign.active? ? 'sign-active' : 'sign-inactive'
    content_tag :div, nil, title: orb_title, class: orb_class
  end
end
