class UsersController < ApplicationController
  before_filter :authenticate_user!
  set_tab :users
  access_control do
    allow :admin
    allow :functionary, :to => [:show, :edit]
  end
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    roles = params[:role]
    if roles
      roles.each do |r|
        role = Role.find(:first, :conditions=>{:name=>r})
        @user.roles << role
      end
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @roles = Array.new
    Role.all.each do |r|
      @roles.push(r.name)
    end
    @selectedroles = Array.new
    @user.roles.each do |r|
      @selectedroles.push(r.name)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    roles = params[:role]
    if roles
      @user.roles.each do |r|
        found = false
        roles.each do |s|
          if s == r.name
            found = true
          end
        end
        if !found
          @user.roles.delete(r)
        end
      end
      roles.each do |r|
        role = Role.find(:first, :conditions=>{:name=>r})
        if !@user.roles.include?(role)
          @user.roles << role
        end
      end
    else
      @user.roles.each do |r|
        @user.roles.delete(r)
      end
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])

    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
