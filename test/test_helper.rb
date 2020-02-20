require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!
Dir.glob(File.expand_path("../../[0-9]*", __FILE__)).each { |path| $LOAD_PATH.unshift(path) }
