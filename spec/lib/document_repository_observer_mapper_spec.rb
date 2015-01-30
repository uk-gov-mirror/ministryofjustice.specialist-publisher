require "fast_spec_helper"
require "document_repository_observer_mapper"

RSpec.describe DocumentRepositoryObserverMapper do
  subject(:mapper) { DocumentRepositoryObserverMapper.new(mapping) }

  let(:mapping) {
    {
      "foo" => foo,
      "bar" => bar,
    }
  }

  let(:foo) {
    double(:tuple,
           repository: double(:repository),
           observer: double(:observer)
    )
  }

  let(:bar) {
    double(:tuple,
           repository: double(:repository),
           observer: double(:observer)
    )
  }

  describe "#all" do
    it "returns repositories and observers for all document types" do
      listeners = mapper.all
      expect(listeners.size).to eq(2)
      expect(listeners).to eq([foo, bar])
    end
  end

  describe "#for_types" do
    it "returns the repository and observer for a single document type" do
      listeners = mapper.for_types("foo")
      expect(listeners.size).to eq(1)
      expect(listeners).to eq([foo])
    end

    it "returns the repository and observer for multiple document types" do
      listeners = mapper.for_types("foo", "bar")
      expect(listeners.size).to eq(2)
      expect(listeners).to eq([foo, bar])
    end

    it "raises if an unknown document type is requested" do
      expect { mapper.for_types("baz") }.to raise_error
    end
  end
end
