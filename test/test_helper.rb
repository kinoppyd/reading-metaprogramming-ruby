require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!
paths = ENV["CI"] ? "../../answers/[0-9]*" : "../../[0-9]*"
Dir.glob(File.expand_path(paths, __FILE__)).each { |path| $LOAD_PATH.unshift(path) }
