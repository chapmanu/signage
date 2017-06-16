module SignsHelper
  VISIBILITY_STATES = {
    'listed' => 'Public',
    'hidden' => 'Private'
  }

  def sign_name_with_approval_details(sign)
    if sign.owned_by?(current_user)
      sign.name
    else
      "#{sign.name} <strong>(requires approval)</strong>".html_safe
    end
  end

  def sign_status_orb(sign)
    orb_title = sign.private? ? 'Sign is private' : sign.active? ? 'Sign is live' : 'Sign is inactive'
    orb_class = sign.private? ? 'sign-private' : sign.active? ? 'sign-active' : 'sign-inactive'
    content_tag :div, nil, title: orb_title, class: orb_class
  end

  def video_background
    if current_page?(controller: 'signs', action: 'play')
      video_tag("<%= slide.background %>", id: "js-background-video", class: "ui-slide-background", preload: "auto", loop: true)
    else
      video_tag("<%= slide.background %>", controls: true, muted: true, id: "js-background-video", class: "ui-slide-background", preload: "auto", loop: true)
    end
  end
end
