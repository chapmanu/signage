class SponsorsController < ApplicationController
  before_action :set_sponsor, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
  	@sponsors = Sponsor.all.order(:name)
  end

  def show
  end

  def new
  	@sponsor = Sponsor.new
  end

  def edit
  end

  def create
    @sponsor = Sponsor.new(sponsor_params)

  	respond_to do |format|
  	  if @sponsor.save
  	  	format.html { redirect_to @sponsor, notice: 'Sponsor was successfully created.' }
        format.json { render :show, status: :created, location: @Sponsor }
      else
      	format.html { render :edit }
      	format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
  	end
  end

  def update
    respond_to do |format|
      if @sponsor.update(sponsor_params)
        format.html { redirect_to @sponsor, notice: 'Sponsor was successfully updated.' }
        format.json { render :show, status: :ok, location: @sponsor }
      else
        format.html { render :edit }
        format.json { render json: @sponsor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@sponsor.destroy
    respond_to do |format|
      format.html { redirect_to sponsors_url, notice: 'Sponsor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
  	end

  	def sponsor_params
  	  params.require(:sponsor).permit(:name, :icon)
  	end
end