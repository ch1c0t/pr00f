require 'pr00f'
require 'pry'

reports = Dir["./meta_proof/**/*.rb"].map do |proof|
  Pr00f::Report.new IO.read proof
end

binding.pry
reports
