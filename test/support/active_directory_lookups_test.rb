module ActiveDirectoryLookupsTest
  def test_create_from_ldap_identites
    VCR.use_cassette(:lookup_kerr105) do
      assert_difference 'User.count', 1 do
        User.create_or_update_from_active_directory('kerr105')
      end
    end
  end

  def test_create_or_update_returns_a_user
    VCR.use_cassette(:lookup_kerr105) do
      user = User.create_or_update_from_active_directory('kerr105')
      assert_equal(User, user.class)
    end
  end

  def test_lookup_returns_a_hash_with_proper_keys
    VCR.use_cassette(:lookup_kerr105) do
      data = User.lookup_in_active_directory('kerr105')
      assert %w(email firstname lastname).all? { |key| data.has_key?(key) }
    end
  end
end