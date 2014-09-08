require "pdfkit"

class ManualPDFExporter
  def initialize(manual, document_renderer)
    @manual = manual
    @document_renderer = document_renderer
  end

  def call
    kit = PDFKit.new(manual_content, :page_size => 'Letter')
    # kit.stylesheets << '/path/to/css/file'
    kit.to_file("tmp/manual-#{SecureRandom.uuid}.pdf")
  end

private
  attr_reader :manual, :document_renderer

  def manual_content
    manual_title + rendered_documents.map(&:body).join("\n")
  end

  def manual_title
    "<h1>#{manual.title}</h1><hr />"
  end

  def rendered_documents
    manual.documents.map do |document|
      document_renderer.call(document)
    end
  end
end
