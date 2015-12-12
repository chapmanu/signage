module IntegrationHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Chapman Username', with: user.email
    fill_in 'Password', with: 'anything'
    Net::LDAP.stub_any_instance(:bind, true) do
      VCR.use_cassette("#{user.email}_sign_in") do
        submit_form
      end
    end


  end
end