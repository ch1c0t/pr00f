require 'pr00f'

Dir["./meta_proof/**/*.rb"].each do |proof|
  Pr00f::DSL.run IO.read proof
  puts "The #{proof} is sound."
end
