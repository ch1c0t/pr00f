lib = File.expand_path './lib/'
$:.unshift lib unless $:.include? lib

Gem::Specification.new do |g|
  g.name    = 'pr00f'
  g.version = '0.0.0'
  g.summary = 'An errorproof approach to testing Ruby code.'
  g.authors = ['Anatoly Chernow']

  g.require_path = 'lib'
  g.add_development_dependency 'pry'
  g.add_development_dependency 'pry-byebug'
end
