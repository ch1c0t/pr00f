constant Constant do
  instance do
    Constant.new Constant do
      respond_to :new # Indeed!
    end
  end

  all_instances do
    respond_to :respond_to
    respond_to :constants
    respond_to :instance
    respond_to :all_instances
  end
end
