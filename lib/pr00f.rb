%w!
  test
  core_ext/type
  core_ext/object
  testable
  constant
  instance
!.each { |file| require_relative "pr00f/#{file}" }
