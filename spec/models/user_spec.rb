require 'spec_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = User.create(email: "coder@skillcrush", password: "password", first_name: "Billy", last_name: "Bob")
  end

  after(:all) do
    if !@user.destroyed?
      @user.destroy
    end
  end

  it 'authenticates and returns a user when valid email and password passed in' do
    u = User.authenticate(@user.email, @user.password)
    expect(u).to be
  end

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

end
