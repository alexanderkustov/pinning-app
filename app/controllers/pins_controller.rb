class PinsController < ApplicationController
  before_action :require_login, except: [ :show, :show_by_name]

  def index
    @pins = Pin.all
  end

  def show
    @pin = Pin.find(params[:id])
    @users = User.find(@pin.pinnings.map(&:user_id))
  end

  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = User.find(@pin.pinnings.map(&:user_id))
    render :show
  end

  def new
    @pin = Pin.new
  end

  def create
  	@pin = Pin.new(pin_params)

    @errors = @pin.errors unless @pin.valid?

  	if @pin.save
  		flash[:success] = "Pin has been created."
  		redirect_to @pin
  	else
  		flash.now[:danger] = "Pin has not been created."
  		render :new
  	end
  end

  def edit
    @pin = Pin.find(params[:id])
  end

  def update
   @pin = Pin.find(params[:id])
   @pin.update(pin_params)

   if @pin.valid?
     @pin.save
     redirect_to pin_path(@pin)
   else
     @errors = @pin.errors
     render :edit
   end
 end

 def repin
  @pin = Pin.find(params[:id])
  @pin.pinnings.create(user: current_user)
  redirect_to user_path(current_user)
end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :category_id, :user_id)
  end

end
