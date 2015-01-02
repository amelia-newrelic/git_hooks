#!/usr/bin/env ruby

require_relative '../bash_colors'

require 'optparse'

OptionParser.new do |opts|
  opts.on("--about") do
    puts "Makes sure code does not contain any breaking point"
  end
end.parse!



class PreCommitHandler

  attr_accessor :file_errors

  def initialize
    @file_errors = []
  end

  def handle
    reject if code_contains_breakpoints?
  end

  private

  def code_contains_breakpoints?
    commiting_files.each do |file|
      analyzer = FileAnalyzer.new(file)
      if analyzer.contains_breakpoints?
        file_errors << analyzer.errors
      end
    end
    file_errors.count > 0
  end

  def commiting_files
    %x{git diff --name-only --cached}.split("\n")
  end

  def reject
    messages = ["Your attempt to COMMIT was rejected" ]
    messages << nil
    messages << file_errors
    messages << nil
    messages << "If you still want to commit then you need to ignore the pre_commit git hook by executing following command."
    messages << "git commit --no-verify OR git commit -n"
    feedback messages
  end

  def feedback(messages)
    puts "*"*40
    [messages].flatten.each do |message|
      puts message
    end
    puts "*"*40

    exit 1
  end

  class FileAnalyzer
    attr_reader :file, :extension
    attr_accessor :errors

    def initialize(file)
      @file = file
      @extension = file.split(".").last
      @errors = []
    end

    def contains_breakpoints?
      return false if skip_file?
      file_types[extension.to_sym][:breakpoints].each do |breakpoint|
        text = %x{git show :#{file}}
        if text.scan(/#{breakpoint}/).count > 0
          errors << "File #{Bash::Text.red do "./#{file}" end } contains #{breakpoint}"
        end
      end
      errors.count > 0
    end

    def file_types
      {
        rb: {
          breakpoints: ["binding.pry", "debugger"],
          comment: ["#"]
        },
        js: {
          breakpoints: ["debugger"],
          comment: "//"
        },
        coffee: {
          breakpoints: ["debugger"],
          comment: "#"
        }
      }
    end

    def skip_file?
      extension.nil? || !(file_types.keys.include? extension.to_sym) || !(File.file? file)
    end
  end
end

PreCommitHandler.new.handle
