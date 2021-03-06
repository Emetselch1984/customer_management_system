class Admin < User
  include EmailHolder
  include PersonalNameHolder
  before_validation do
    self.email = normalize_as_email(email)
  end
  validates :email, presence: true, "valid_email_2/email": true,
                    uniqueness: { case_sensitive: false }, length: { maximum: 256 }
end
