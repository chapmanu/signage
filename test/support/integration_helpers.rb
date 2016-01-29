module IntegrationHelpers
  def sign_in(user)
    Net::LDAP.stub_any_instance(:bind, true) do
      VCR.use_cassette("#{user.email}_sign_in") do
        visit new_user_session_path
        fill_in 'Chapman Username', with: user.email
        fill_in 'Password', with: 'anything'
        click_button 'Log in'
      end
    end
  end

  def sign_out
    visit root_url
    click_link 'Sign Out'
  end
end