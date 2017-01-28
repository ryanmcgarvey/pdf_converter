class PdfController < ApplicationController
  def create
    if params[:pdf_content].is_a? String
      content = Converter.from_string params[:pdf_content]
    else
      pdf_file_path = params[:pdf_content].tempfile.path
      content = Converter.new(pdf_file_path).execute
    end
    render html: content.html_safe
  end
end
