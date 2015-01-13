require "spec_helper"
require "spec/exporters/formatters/abstract_indexable_formatter_spec"
require "formatters/finder_indexable_formatter"

RSpec.describe FinderIndexableFormatter do
  let(:document) {
    double(
      :finder,
      title: "Competition and Markets Authority cases",
      base_path: "/cma-cases",
      description: "",
    )
  }

  subject(:formatter) { FinderIndexableFormatter.new(document) }

  it_should_behave_like "an indexable formatter"
end
