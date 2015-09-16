require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  tests Devise::SessionsController
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'login with valid credentials' do
    VCR.use_cassette(:lookup_kerr105) do
      Net::LDAP.stub_any_instance(:bind, true) do
        post :create, user: { email: 'kerr105@chapman.edu', password: 'blahblahbalah' }
      end
      assert_redirected_to admin_index_path
    end
  end

  test 'login without valid credentials' do
    Net::LDAP.stub_any_instance(:bind, false) do
      post :create, user: { email: 'kerr105@chapman.edu', password: 'blahblahbalah' }
    end
    assert response.body.include?('Invalid email or password.')
  end

  test 'the ldap server throws an error' do
    skip("do this next")
  end
end