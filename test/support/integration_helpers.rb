module IntegrationHelpers
  def sign_in(user)
    Net::LDAP.stub_any_instance(:bind, true) do
      VCR.use_cassette("#{user.email}_sign_in") do
        post_via_redirect new_user_session_path, 'user[email]' => user.email, 'user[password]' => 'anything'
      end
    end
  end
end