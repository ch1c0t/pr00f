constant Symbol do
  respond_to :all_symbols, with: [Array, of: Symbol]

  respond_to :=== do
    sig Symbol do
      with { true }
    end
    sig String do
      with { false }
    end
  end

  instance :ascii { :ascii }
  instance :empty { :"" }

  all_instances do
    %i!
      capitalize
      downcase
      upcase
      swapcase
      intern
      to_sym
      succ
      next
    !.each do |m|
      respond_to m, with: Symbol
    end

    [:casecmp, :<=>].each do |m|
      respond_to m, Symbol do
        with { either [1, 0, -1, nil] }
      end
    end

    [:[], :slice].each do |m|
      respond_to m do
        sig Integer
        sig Integer, Integer

        with maybe String
      end
    end

    [:id2name, :inspect, :to_s].each do |m|
      respond_to m, with: String
    end

    [:length, :size].each do |m|
      respond_to m, with: Integer
    end

    [:match, :=~].each do |m|
      respond_to m do with maybe Integer end
    end

    respond_to :encoding, with: Encoding
    respond_to :==, Symbol, with: Bool
    respond_to :to_proc, with: Proc
  end

  empty do
    respond_to :empty?, with: ->{true}
  end
end
