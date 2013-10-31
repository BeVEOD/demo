# -*- encoding : utf-8 -*-
require 'stringio'
require 'filesystem.rb'
require 'fakefs/safe'
require 'cgi'
require 'cgi/session'
require 'cgi/session/pstore'

module IrbjaxEngine
  extend self

  class IrbjaxSession
    attr_accessor :session

    def initialize(session)
      @session = session

      @session["start_time"]        ||= Time.now
      @session["current_statement"] ||= ''
      @session["past_commands"]     ||= ''
    end

    [:current_statement, :past_commands, :start_time].each do |accessor|
      define_method(accessor) { @session[accessor.to_s] }
      define_method(:"#{accessor.to_s}=") { |new_val| @session[accessor.to_s] = new_val }
    end
  end

  class Output
    attr_reader :type, :result, :output, :error, :indent_level, :javascript

    def self.standard(params = {})
      Output.new :type => :standard, :result => params[:result],
        :output => params[:output] || ''
    end

    def self.illegal
      Output.new :type => :illegal
    end

    def self.javascript(js)
      Output.new :type => :javascript, :javascript => js
    end

    def self.no_output
      Output.standard :result => nil
    end

    def self.line_continuation(level)
      Output.new :type => :line_continuation, :indent_level => level
    end

    def self.error(params = {})
      params[:error] ||= StandardError.new('Irbjax Error')
      params[:error].message.gsub! /\(eval\):\d*/, '(Irbjax):1'
      Output.new :type => :error, :error => params[:error],
        :output => params[:output] || ''
    end

    def format
      case @type
      when :line_continuation
        ".." * @indent_level
      when :error
        @output + "\033[1;33m#{@error.class}: #{@error.message}"
      when :illegal
        "\033[1;33mYou aren't allowed to run that command!"
      when :javascript
        "\033[1;JSm#{@javascript}\033[m "
      else
        @output + "=> \033[1;20m#{@result.inspect}"
      end
    end

    protected
      def initialize(values = {})
        values.each do |variable, value|
          instance_variable_set("@#{variable}", value)
        end
      end
  end

  class << self
    attr_accessor :session
    #IrbjaxEngine.session = IrbjaxEngine::IrbjaxSession.new
  end

  def run_line(code)
    case code.strip
    when '!INIT!IRB'
      return Output.no_output
    when 'reset'
      session[:current_statement] = ''
      return Output.no_output
    when 'time'
      seconds = (Time.now - session[:start_time]).ceil
      return Output.standard :result =>
        if seconds < 60; "#{seconds} seconds"
        elsif seconds < 120; "1 minute"
        else; "#{seconds / 60} minutes"
        end
    end

    # run something
    FakeFS.activate!
    stdout_id = $stdout.to_i
    $stdout = StringIO.new
    cmd = <<-EOF
    #{FileSystem}
    $SAFE = 1
    #{session[:past_commands]}
    $stdout = StringIO.new
    begin
      #{session[:current_statement]}
      #{code}
    end
    EOF
    begin
     result = Thread.new { eval cmd, TOPLEVEL_BINDING }.value
    rescue SecurityError
      return Output.illegal
    rescue Exception => e
      return Output.error :error => e, :output => get_stdout
    ensure
      output = get_stdout
      $stdout = IO.new(stdout_id)
      FakeFS.deactivate!
    end

    session[:current_statement] += "\n" + code
    session[:past_commands] += "\n" + session[:current_statement].strip
    session[:current_statement] = ''

    return result if result.is_a? Output and result.type == :javascript
    Output.standard :result => result, :output => output
  end

  private
    def get_stdout
      raise TypeError, "$stdout is a #{$stdout.class}" unless $stdout.is_a? StringIO
      $stdout.rewind
      $stdout.read
    end
end

