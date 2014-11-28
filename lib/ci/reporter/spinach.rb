# encoding: utf-8
require 'ci/reporter/core'
require 'ci/reporter/spinach/version'
require 'spinach'

module CI
  module Reporter
    class Spinach < ::Spinach::Reporter
      include SpinachVersion

      attr_reader :out, :error

      def initialize(options = nil)
        @options = options
        @out = options[:output] || $stdout
        @error = options[:error] || $stdout
        @report_manager = ReportManager.new('features')
      end

      def before_feature_run(feature)
        name = feature.is_a?(Hash) ? feature['name'] : feature.name
        out.puts "================"
        out.puts "Feature: #{name}"
        @test_suite = TestSuite.new(name)
        @test_suite.start
      end

      def before_scenario_run(scenario, step_definitions = nil)
        name = scenario.is_a?(Hash) ? scenario['name'] : scenario.name
        out.puts "Scenario: #{name}"
        @test_case = TestCase.new(name)
        @test_case.start
      end

      def on_successful_step(step, step_location, step_definitions = nil)
        out.puts "(+) #{step.keyword} #{step.name}"
      end

      def on_undefined_step(step, failure, step_definitions = nil)
        failure = SpinachFailure.new(:error, step, failure, nil)
        error.puts failure.to_s
        @test_case.failures << failure
      end

      def on_failed_step(step, failure, step_location, step_definitions = nil)
        failure = SpinachFailure.new(:failed, step, failure, step_location)
        error.puts failure.to_s
        @test_case.failures << failure
      end

      def on_error_step(step, failure, step_location, step_definitions = nil)
        failure = SpinachFailure.new(:error, step, failure, step_location)
        error.puts failure.to_s
        @test_case.failures << failure
      end

      def after_scenario_run(scenario, step_definitions = nil)
        @test_case.finish
        @test_suite.testcases << @test_case
        @test_case = nil
      end

      def after_feature_run(feature)
        @test_suite.finish
        @report_manager.write_report(@test_suite)
        @test_suite = nil
      end
    end

    class SpinachFailure
      def initialize(type, step, failure, step_location)
        @type = type
        @step = step
        @failure = failure
        @step_location = step_location
      end

      def failure?
        @type == :failed
      end

      def error?
        @type == :error
      end

      def name
        @failure.class.name
      end

      def message
        @failure.message
      end

      def location
        @failure.backtrace.join("\n")
      end

      def to_s
        "(x) #{@step.keyword} #{@step.name}\n#{@type}\n#{@failure.message}\n#{location}"
      end
    end
  end
end

class Spinach::Reporter
  CiReporter = ::CI::Reporter::Spinach
end
