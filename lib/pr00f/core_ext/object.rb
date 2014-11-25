class Object
  def type &definition
    if block_given?
      @type = Type.new self, &definition
    else
      @type ||= Type.new self
    end
  end

  def type= new_type
    @type = new_type
  end
end
