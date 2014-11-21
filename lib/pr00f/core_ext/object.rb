class Object
  def type &definition
    @type ||= if block_given?
      Type.new self, &definition
    else
      Type.new self
    end
  end

  def type= new_type
    @type = new_type
  end
end
