class Object
  def type &definition
    @type ||= Type.new &definition
  end
end
