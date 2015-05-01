require 'spec_helper'

describe PreCommitHandler do
  let(:handler) { self.described_class.new }

  before :each do
    allow(File).to receive(:file?).with(anything).and_return(true)
  end


  describe "ruby files" do
    before :each do
      allow_any_instance_of(Object).to receive(:`).with("git diff --name-only --cached").and_return("file.rb")
    end

    describe "that are valid" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.rb").and_return(" some ruby code ")
      end

      it "will not fail" do
        expect(STDOUT).to receive(:puts).never
        expect {handler.handle}.not_to raise_error
      end
    end

    describe "with binding.pry" do

      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.rb").and_return("dsafa binding.pry")
      end

      it "will fail" do
        message=<<-EOF.strip_heredoc
        ****************************************
        Your attempt to COMMIT was rejected

        File \e[31m./file.rb\e[39m contains binding.pry

        If you still want to commit then you need to ignore the pre_commit git hook by executing following command.
        git commit --no-verify OR git commit -n
        ****************************************
        EOF
        allow(File).to receive(:file?).with(anything).and_return(true)
        expect(STDOUT).to receive(:puts).with(message.chomp)
        expect {handler.handle}.to raise_error SystemExit
      end
    end
    describe "with debugger" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.rb").and_return("dsafa debugger")
      end

      it "will fail" do
        message=<<-EOF.strip_heredoc
        ****************************************
        Your attempt to COMMIT was rejected

        File \e[31m./file.rb\e[39m contains debugger

        If you still want to commit then you need to ignore the pre_commit git hook by executing following command.
        git commit --no-verify OR git commit -n
        ****************************************
        EOF
        allow(File).to receive(:file?).with(anything).and_return(true)
        expect(STDOUT).to receive(:puts).with(message.chomp)
        expect {handler.handle}.to raise_error SystemExit
      end
    end

    describe "with byebug" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.rb").and_return("dsafa byebug")
      end

      it "will fail" do
        message=<<-EOF.strip_heredoc
        ****************************************
        Your attempt to COMMIT was rejected

        File \e[31m./file.rb\e[39m contains byebug

        If you still want to commit then you need to ignore the pre_commit git hook by executing following command.
        git commit --no-verify OR git commit -n
        ****************************************
        EOF
        allow(File).to receive(:file?).with(anything).and_return(true)
        expect(STDOUT).to receive(:puts).with(message.chomp)
        expect {handler.handle}.to raise_error SystemExit
      end
    end

  end

  describe "javascript files" do
    before :each do
      allow_any_instance_of(Object).to receive(:`).with("git diff --name-only --cached").and_return("file.js")
    end

    describe "that are valid" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.js").and_return(" some js code ")
      end

      it "will not fail" do
        expect(STDOUT).to receive(:puts).never
        expect {handler.handle}.not_to raise_error
      end
    end

    describe "with debugger" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.js").and_return("dsafa debugger")
      end

      it "will fail" do
        message=<<-EOF.strip_heredoc
        ****************************************
        Your attempt to COMMIT was rejected

        File \e[31m./file.js\e[39m contains debugger

        If you still want to commit then you need to ignore the pre_commit git hook by executing following command.
        git commit --no-verify OR git commit -n
        ****************************************
        EOF
        allow(File).to receive(:file?).with(anything).and_return(true)
        expect(STDOUT).to receive(:puts).with(message.chomp)
        expect {handler.handle}.to raise_error SystemExit
      end
    end


  end
  describe "coffee files" do
    before :each do
      allow_any_instance_of(Object).to receive(:`).with("git diff --name-only --cached").and_return("file.coffee")
    end

    describe "that are valid" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.coffee").and_return(" some js code ")
      end

      it "will not fail" do
        expect(STDOUT).to receive(:puts).never
        expect {handler.handle}.not_to raise_error
      end
    end

    describe "with debugger" do
      before :each do
        allow_any_instance_of(Object).to receive(:`).with("git show :file.coffee").and_return("dsafa debugger")
      end

      it "will fail" do
        message=<<-EOF.strip_heredoc
        ****************************************
        Your attempt to COMMIT was rejected

        File \e[31m./file.coffee\e[39m contains debugger

        If you still want to commit then you need to ignore the pre_commit git hook by executing following command.
        git commit --no-verify OR git commit -n
        ****************************************
        EOF
        allow(File).to receive(:file?).with(anything).and_return(true)
        expect(STDOUT).to receive(:puts).with(message.chomp)
        expect {handler.handle}.to raise_error SystemExit
      end
    end


  end

end
