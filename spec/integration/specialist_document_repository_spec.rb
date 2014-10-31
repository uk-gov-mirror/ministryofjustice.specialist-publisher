require "spec_helper"

describe SpecialistDocumentRepository do
  before do
    @editions = []
    20.times do |n|
      @editions << FactoryGirl.create(
        :specialist_document_edition,
        document_type: "cma_case",
        updated_at: n.days.ago
      )
    end
  end

  subject(:repository) {
    SpecialistPublisherWiring.get(:repository_registry).cma_case_repository
  }

  let(:ordered_by_updated_at_document_ids) {
    @editions.sort { |a, b| b.updated_at <=> a.updated_at }.map { |e| e.document_id }
  }

  describe "#all" do
    it "returns all cma cases" do
      expect(repository.all.size).to eq(@editions.size)
    end

    it "returns cma cases ordered by last updated at" do
      repository_document_ids = repository.all.map(&:id)

      expect(repository_document_ids).to eq(ordered_by_updated_at_document_ids)
    end

    context "with an offset of 10 and limit of 2" do
      it "returns the 11th and 12th documents by updated_at" do
        returned_documents = repository.all(2, 10).map(&:id)
        expected_documents = ordered_by_updated_at_document_ids[10...12]

        expect(returned_documents).to eq(expected_documents)
      end
    end
  end
end
