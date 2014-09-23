module GitDayOne
  class DayOneFormatter
    attr_accessor :commits, :project

    def initialize(project, commits)
      @project = project
      @commits = commits
    end

    def get_message
      <<-eos
project : #{project}
commits : #{commits.length}
additions : #{commits.inject(0) {|sum, commit| sum + commit.additions}}
deletions : #{commits.inject(0) {|sum, commit| sum + commit.deletions}}

commit messages :
#{ commit_messages }
      eos
    end

    def commit_messages
      commits.reverse.map { |c| additions_del_string(c) + " " + c.date.strftime("%H:%M") + "\t" + branch(c) +  c.msg_body.join("\n") }.join("\n")
    end

    def additions_del_string(commit)
      "+#{commit.additions} | -#{commit.deletions}"
    end

    def branch(commit)
      if commit.branches && commit.branches.length == 1
        "[#{commit.branches[0].gsub(/\A[\* ]*(.*)/, '\1')}] "
      else
        ""
      end
    end
  end
end
