require 'minitest/spec'
require 'minitest/rg'
require 'minitest/autorun'
require 'minitest/reporters'

$LOAD_PATH << File.expand_path("../../lib", __FILE__)

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

class MiniTest::Unit::TestCase

  protected

  def test_filename(filename)
    file_dir = File.expand_path('../files', __FILE__)
    File.join(file_dir, filename)
  end

end
