class A
  B = nil
  C = nil

  class << self
    def class_method0;end
    def class_method1;end
  end

  def initialize args = :default_args
  end

  def ololo;end
  
  def instance_method0;end
  def instance_method1;end
  def instance_method2;end
end

constant A do
  constants [:B, :C]

  respond_to :class_method0
  respond_to :class_method1

  instance(:nullary) { A.new }
  instance :with_args do
    A.new :args
  end

  all_instances do
    respond_to :ololo
  end

  nullary do
    respond_to :instance_method0
    respond_to :instance_method1
  end

  with_args do
    respond_to :instance_method2
  end
end
