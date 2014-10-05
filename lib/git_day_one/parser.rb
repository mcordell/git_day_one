module GitDayOne
  class Parser
    attr_accessor :configuration
    COMMIT_RE = /^commit ([0-9a-f]*)\b/
    DATE_RE = /^date ([A-Za-z]*,\s\d+\s[A-Za-z]*\s\d+\s\d+:\d+:\d+\s[+-]\d+)$/
    ADD_DEL_RE = /^(\d*)\s*(\d*)/

    def initialize(configuration)
      @configuration = configuration
    end

    def run_git_command
      return nil unless configuration
      `#{configuration.git_command}`.split("\n")
    end

    def run_branch_lookup(hash = nil)
      return nil unless configuration && hash
      `git branch --contains #{hash}`.split("\n")
    end

    def command_result
       @command_result ||= run_git_command
    end

    def parse
      return nil unless command_result
      commit_blocks.map { |a| parse_block(a) }
    end

    def start_commit_indices
      @indices ||= command_result.collect.with_index do |line, i|
        i if line.chomp == configuration.start_commit
      end.compact
    end

    def commit_blocks
      ranges = start_commit_indices.map.with_index do |start, i|
        end_of_range = i + 1 == start_commit_indices.length ? command_result.length : start_commit_indices[i + 1]
        [start, end_of_range - start]
      end
      ranges.map do |rng|
        command_result.slice(*rng)
      end
    end

    def parse_block(commit_block)
      commit = GitDayOne::Commit.new
      status = nil
      commit_block.each do |line|
        if line.chomp == configuration.start_commit
          status = :body
        elsif line.strip == configuration.stop_commit
          status = :additions
        elsif status == :body
          commit_match = COMMIT_RE.match(line)
          date_match = DATE_RE.match(line)
          if commit_match
            commit.hash = commit_match[1]
          elsif date_match
            commit.date = DateTime.parse(date_match[1], GitDayOne::Configuration::GIT_CMD_DATE_FORMAT) if date_match
          else
            commit.msg_body.push(line)
          end
        elsif status == :additions
          add_del_match = ADD_DEL_RE.match(line)
          if add_del_match
            commit.additions += add_del_match[1].to_i
            commit.deletions += add_del_match[2].to_i
          end
        end
      end
      commit.branches = run_branch_lookup(commit.hash)
      commit
    end
  end
end
