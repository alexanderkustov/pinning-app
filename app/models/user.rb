class User < ActiveRecord::Base
  has_secure_password
  has_many :pinnings
  has_many :pins, through: :pinnings

  validates_presence_of :first_name, :last_name, :email, :password
  validates_uniqueness_of :email


  def self.authenticate(email, password)
    @user = User.find_by_email(email)

    if !@user.nil?
      if @user.authenticate(password)
        return @user
      end
    end


  end

end
