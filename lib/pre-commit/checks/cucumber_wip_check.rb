module PreCommit
  class CucumberWipCheck

    attr_accessor :staged_files, :error_message, :grep_command

    def self.call(quiet=false)
      dirs = ['features/'].reject {|d| !File.exists?(d)}
      check = new
      check.staged_files = Utils.staged_files(*dirs)

      result = check.run
      if !quiet && !result
        $stderr.puts check.error_message
        $stderr.puts
        check.print_dash_n_reminder
      end
      result
    end

    def run
      return true if staged_files.empty?

      if detected_bad_code?
        @error_message = "pre-commit: cucumber @wip tag(s) found:\n"
        @error_message += instances_of_cucumber_wip_tag_violations
        false
      else
        true
      end
    end

    def detected_bad_code?
      !system("git diff --cached -Sdebugger --quiet --exit-code")
    end

    def instances_of_cucumber_wip_tag_violations
      cmd = grep_command || "git grep"
      `#{cmd} -nH '\b@wip\b' #{staged_files}`
    end

    def print_dash_n_reminder
      $stderr.puts 'You can bypass this check using `git commit -n`'
      $stderr.puts
    end

  end
end
