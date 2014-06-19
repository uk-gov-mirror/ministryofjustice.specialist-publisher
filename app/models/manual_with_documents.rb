require "delegate"

class ManualWithDocuments < SimpleDelegator
  def initialize(document_builder, manual, attrs)
    @manual = manual
    @documents = attrs.fetch(:documents)
    binding.pry if @documents.first.is_a?(Enumerator)
    @document_builder = document_builder
    super(manual)
  end

  def documents
    @documents = @documents.to_a
  end

  def build_document(attributes)
    document = document_builder.call(
      self,
      attributes
    )

    add_document(document)

    document
  end

  def publish
    manual.publish do
      documents.each(&:publish!)
    end
  end

  private
  attr_reader :document_builder, :manual

  def add_document(document)
    @documents = @documents.to_a
    @documents.push(document)
    nil
  end
end
