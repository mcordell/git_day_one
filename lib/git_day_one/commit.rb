module GitDayOne
  class Commit
    attr_accessor :hash, :date, :msg_body, :additions, :deletions
    def initialize
      @msg_body = []
      @additions = 0
      @deletions = 0
    end

    def to_s
      "#{hash} #{date} #{additions} #{deletions} #{msg_body}"
    end
  end
end
