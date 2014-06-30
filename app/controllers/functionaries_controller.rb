class FunctionariesController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource
  
  # GET /functionaries
  # GET /functionaries.xml
  def index
    @functionaries = Functionary.joins(:user).order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @functionaries }
    end
  end
  
  def new
    @functionary = Functionary.new
    @functionary.build_user
  end

  def create
    @functionary = Functionary.new(params[:functionary])

    user = User.new(params[:functionary][:user_attributes])
    user.password = '123456'
    user.first_password = '123456'

    unless user.save
      flash[:alert] = 'Could not create new functionary.'
      render 'new'
      return
    end

    @functionary.user_id = user.id

    if @functionary.save
      flash[:notice] = 'New functionary created. Remember to add a role to this user'
      redirect_to functionary_path(@functionary)
    else
      user.destroy
      flash[:alert] = 'Could not create new functionary.'
      render 'new'
    end
  end

  # GET /functionaries/1
  # GET /functionaries/1.xml
  def show
    @functionary = Functionary.find(params[:id])
    @roles = @functionary.user.roles

    if can? :manage, Functionary
      @participants = Participant.find(:all, :joins=>'JOIN functionaries_participants fp ON fp.participant_id = participants.id', :conditions=>'fp.functionary_id = '+params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @functionary }
    end
  end

  # GET /functionaries/1/edit
  def edit
    @functionary = Functionary.find(params[:id])

    raise CanCan::AccessDenied unless current_user == @functionary.user or (can? :manage, Functionary)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @functionary }
    end
  end

  # PUT /functionaries/1
  # PUT /functionaries/1.xml
  def update
    @functionary = Functionary.find(params[:id])

    raise CanCan::AccessDenied unless current_user == @functionary.user or (can? :manage, Functionary)

    respond_to do |format|
      if @functionary.update_attributes(params[:functionary])
        format.html { redirect_to(@functionary, :notice => 'Functionary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @functionary.errors, :status => :unprocessable_entity }
      end
    end
  end

  def impersonate
    @functionary = Functionary.find(params[:id])
    sign_in(:user, User.find(@functionary.user))
    redirect_to root_url
  end

  def add_role
    @functionary = Functionary.find(params[:id])
    @role = Role.find(params[:role][:id])

    unless @functionary.user.has_role?(@role.name)
      @functionary.user.roles << @role
    end

    render json: @functionary.user.roles.to_json
  end

  def remove_role
    @functionary = Functionary.find(params[:id])
    @role = Role.find(params[:role])

    if @functionary.user.has_role?(@role.name)
      UserRole.find_by_user_id_and_role_id(@functionary.user_id, @role.id).destroy
    end

    render json: Functionary.find(params[:id]).user.roles.to_json
  end

  private
  def sort_column
    Functionary.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
