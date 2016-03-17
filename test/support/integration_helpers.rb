module IntegrationHelpers
  def sign_in(user)
    Net::LDAP.stub_any_instance(:bind, true) do
      VCR.use_cassette("#{user.email}_sign_in_using_#{Capybara.current_driver}") do
        visit new_user_session_path
        fill_in 'Chapman Username', with: user.email
        fill_in 'Password', with: 'anything'
        click_button 'Log in'
      end
    end
  end

  def sign_out
    visit root_path
    click_link 'Sign Out'
  end

  def materialize_select(option_to_select, options)
    id = options[:from]
    parent = find(:xpath, "//*[@id=\"#{id}\"]/..")
    parent.click
    within parent do
      first('li', text: option_to_select).click
    end
  end

  def wait_for_ajax
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_ajax_requests?
      end
    end

    def finished_all_ajax_requests?
      page.evaluate_script('jQuery.active').zero?
    end
end