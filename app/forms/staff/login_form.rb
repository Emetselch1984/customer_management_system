class Staff::LoginForm
  include ActiveModel::Model

  attr_accessor :email, :crypted_password
end
