require 'minitest_helper'
require 'pre-commit/checks/cucumber_wip_check'

class CucumberWipCheckTest < MiniTest::Unit::TestCase

  def test_should_detect_a_cumuber_wip_tag
    check = PreCommit::CucumberWipCheck.new
    check.grep_command = "grep"
    check.staged_files = test_filename('bad.feature')
    assert !check.instances_of_cucumber_wip_tag_violations.empty?
  end

  def test_should_pass_a_file_with_no_cucumber_wip_tag
    check = PreCommit::CucumberWipCheck.new
    check.grep_command = "grep"
    check.staged_files = test_filename('valid.feature')
    assert check.instances_of_cucumber_wip_tag_violations.empty?
  end

  def test_error_message_should_contain_an_error_message_when_a_cucumber_wip_tag_is_found
    check = PreCommit::CucumberWipCheck.new
    def check.detected_bad_code?; true; end
    check.grep_command = "grep"
    check.staged_files = test_filename('bad.feature')
    check.run

    assert_match(/pre-commit: cucumber @wip tag\(s\) found:/, check.error_message)
    assert_match(/bad.feature/, check.error_message)
  end

end
