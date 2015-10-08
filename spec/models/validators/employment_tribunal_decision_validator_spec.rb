require "spec_helper"

require "validators/employment_tribunal_decision_validator"
require_relative "tribunal_decision_sub_category_validator_spec"

RSpec.describe EmploymentTribunalDecisionValidator do

  let(:entity) {
    double(
      :entity,
      title: double,
      summary: double,
      body: "body",
      tribunal_decision_category: category,
      tribunal_decision_country:  double,
      tribunal_decision_decision_date: "2015-11-01",
    )
  }
  let(:document_type) { "employment_tribunal_decision" }

  subject(:validatable) { EmploymentTribunalDecisionValidator.new(entity) }

  it_behaves_like "tribunal decision sub_category validator"

end
