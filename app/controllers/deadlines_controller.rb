class DeadlinesController < ApplicationController
  load_and_authorize_resource

  # GET /deadlines
  # GET /deadlines.xml
  def index

    @deadlines = Deadline.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deadlines }
    end     
  end

  # GET /deadlines/1
  # GET /deadlines/1.xml
  def show
    @deadline = Deadline.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deadline }
    end
  end

  # GET /deadlines/new
  # GET /deadlines/new.xml
  def new
    @deadline = Deadline.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deadline }
    end
  end

  # GET /deadlines/1/edit
  def edit
    @deadline = Deadline.find(params[:id])
  end

  # POST /deadlines
  # POST /deadlines.xml
  def create
    @deadline = Deadline.new(params[:deadline])
    
    respond_to do |format|
      if @deadline.save
        format.html { redirect_to(@deadline, :notice => 'Deadline was successfully created.') }
        format.xml  { render :xml => @deadline, :status => :created, :location => @deadline }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deadline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deadlines/1
  # PUT /deadlines/1.xml
  def update
    @deadline = Deadline.find(params[:id])
    respond_to do |format|
      if @deadline.update_attributes(params[:deadline])
        format.html { redirect_to(@deadline, :notice => 'Question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deadline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @deadline = Deadline.find(params[:id])
    @deadline.destroy
    respond_to do |format|
      format.html { redirect_to(deadlines_url) }
      format.xml  { head :ok }
    end
  end
end
