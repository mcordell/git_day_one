module GitDayOne
  class ProjectRunner
    attr_accessor :configuration, :projects, :totals

    def initialize(configuration)
      @configuration = configuration
      @projects = {}
    end

    def parse_projects
      configuration.projects.each do |name, path|
        Dir.chdir(path) do
          parser = GitDayOne::Parser.new(configuration)
          projects[name] = parser.parse
        end
      end
    end

    def report
      parse_projects
      project_report = ""
      projects.each do |name, commits|
        formater = GitDayOne::DayOneFormatter.new(name, commits)
        update_totals(commits)
        unless commits.empty?
          project_report += formater.get_message + "\n"
        end
      end
      report_header + project_report
    end

    def totals
      @totals ||= { additions: 0, deletions: 0, commits: 0}
    end

    def report_header
      <<-eos
## Git Report
#### Commits: #{totals[:commits]}
#### Additions: #{totals[:additions]}
#### Deletions: #{totals[:deletions]}


### Project Reports

      eos
    end

    def update_totals(commits)
      totals[:commits] += commits.length
      totals[:additions] += commits.inject(0) {|sum, commit| sum + commit.additions}
      totals[:deletions] += commits.inject(0) {|sum, commit| sum + commit.deletions}
    end
  end
end
