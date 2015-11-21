module OwnableModel
  def owned_by?(user)
    self.users.any? do |u|
      u.id == user.id
    end
  end
end