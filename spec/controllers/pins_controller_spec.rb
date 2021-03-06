require 'spec_helper'
RSpec.describe PinsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end

  after(:each) do
    if !@user.destroyed?
      @user.destroy
    end
  end

  describe "GET index" do

      it 'renders the index template' do
        get :index
        expect(response).to render_template("index")
      end

      it 'populates @pins with all pins' do
        get :index
        expect(assigns[:pins]).to eq(Pin.all)
      end

  end

  describe "GET new" do
      it 'responds with successfully' do
        get :new
        expect(response.success?).to be(true)
      end

      it 'renders the new view' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'assigns an instance variable to a new pin' do
        get :new
        expect(assigns(:pin)).to be_a_new(Pin)
      end
    end

    describe "POST create" do
      before(:each) do
        @pin_hash = {
          title: "Rails Wizard",
          url: "http://railswizard.org",
          slug: "rails-wizard",
          text: "A fun and helpful Rails Resource",
          resource_type: "rails"}
      end

      after(:each) do
        pin = Pin.find_by_slug("rails-wizard")
        if !pin.nil?
          pin.destroy
        end
      end

      it 'responds with a redirect' do
        post :create, pin: @pin_hash
        expect(response.redirect?).to be(true)
      end

      it 'creates a pin' do
        post :create, pin: @pin_hash
        expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
      end

      it 'redirects to the show view' do
        post :create, pin: @pin_hash
        expect(response).to redirect_to(pin_url(assigns(:pin)))
      end

      it 'redisplays new form on error' do
        # The title is required in the Pin model, so we'll
        # delete the title from the @pin_hash in order
        # to test what happens with invalid parameters
        @pin_hash.delete(:title)
        post :create, pin: @pin_hash
        expect(response).to render_template(:new)
      end

      it 'assigns the @errors instance variable on error' do
        # The title is required in the Pin model, so we'll
        # delete the title from the @pin_hash in order
        # to test what happens with invalid parameters
        @pin_hash.delete(:title)
        post :create, pin: @pin_hash
        expect(assigns[:errors].present?).to be(true)
      end
    end
    describe "GET edit" do
    before(:each) do
      @pin = Pin.last
      get :edit, :id => @pin.id
    end

    it 'responds with success' do
      expect(response.success?).to be(true)
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'assigns an instance variable @pin to the Pin with the appropriate id' do
      expect(assigns(:pin)).to eq(Pin.last)
    end

    it 'renders the login template when logged out' do
    end
  end

  describe "PUT update" do
    before(:each) do
      @pin_new = {
        title: "New Title",
        text: "New Text."}
      @pin_bad = {
        title: ""}
      @pin = Pin.last
    end

    # Making a POST request to /pins with valid parameters
    it 'responds with success' do
      put :update, :id => @pin.id, :pin => @pin_new
      @pin.reload
      expect(response.redirect?).to be(true)
    end

    it 'updates a pin' do
      put :update, :id => @pin.id, :pin => @pin_new
      @pin.reload
      expect(@pin.title).to eq @pin_new[:title]
    end

    it 'redirects to the show view' do
      put :update, :id => @pin.id, :pin => @pin_new
      @pin.reload
      expect(response).to redirect_to(@pin)
    end

    # Making a POST request to /pins with invalid parameters
    it 'assigns an @errors instance variable' do
      put :update, :id => @pin.id, :pin => @pin_bad
      @pin.reload
      expect(assigns(:errors)).to be
    end

    it 'renders the edit view' do
      put :update, :id => @pin.id, :pin => @pin_bad
      @pin.reload
      expect(response).to render_template(:edit)
    end
  end

end
