require 'rexml/document'
require 'ci/reporter/test_utils/accessor'
require 'ci/reporter/test_utils/shared_examples'
require 'rspec/collection_matchers'

REPORTS_DIR = File.dirname(__FILE__) + '/reports'

describe "Spinach acceptance" do
  include CI::Reporter::TestUtils::SharedExamples
  Accessor = CI::Reporter::TestUtils::Accessor

  let(:report_path) { File.join(REPORTS_DIR, 'FEATURES-Example-Spinach-feature.xml') }

  context "the feature" do
    subject(:result) { Accessor.new(load_xml_result(report_path)) }

    it { is_expected.to have(2).errors }
    it { is_expected.to have(1).failures }
    it { is_expected.to have(4).testcases }

    it_behaves_like "a report with consistent attribute counts"
    it_behaves_like "assertions are not tracked"
    it_behaves_like "nothing was output"

    describe "the test the lazy hacker wrote" do
      subject(:testcase) { result.testcase('Lazy hacker') }

      it { is_expected.to have(1).failures }

      describe "the failure" do
        subject(:failure) { testcase.failures.first }

        it "has a type" do
          expect(failure.type).to match /ExpectationNotMetError/
        end
      end
    end

    describe "the test with missing steps" do
      subject(:testcase) { result.testcase('Missing steps') }

      it { is_expected.to have(1).errors }

      describe "the failure" do
        subject(:failure) { testcase.errors.first }

        it "has a type" do
          expect(failure.type).to match /StepNotDefinedException/
        end
      end
    end

    describe "the test the bad coder wrote" do
      subject(:testcase) { result.testcase('Bad coder') }

      it { is_expected.to have(1).errors }

      describe "the failure" do
        subject(:failure) { testcase.errors.first }

        it "has a type" do
          expect(failure.type).to match /RuntimeError/
        end
      end
    end
  end

  def load_xml_result(path)
    File.open(path) do |f|
      REXML::Document.new(f)
    end
  end
end
