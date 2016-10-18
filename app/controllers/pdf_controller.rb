require 'securerandom'
class PdfController < ApplicationController
  def create
    if params[:pdf_content].is_a? String
      pdf_file_name = File.join Rails.root, (file_name + '.pdf')
      Rails.logger.error "Creating #{pdf_file_name}"
      file = File.new(pdf_file_name, 'w+')
      file.write(params[:pdf_content])
      execute(file.path)
      file.close
      Rails.logger.error `rm #{pdf_file_name}`
    else
      execute(params[:pdf_content].tempfile.path)
    end
  end

  private

  def execute(pdf_file_name)
    Rails.logger.error "Converting #{pdf_file_name}"
    cmd = "pdf2htmlEX --data-dir pdf2htmlex_config --printing=0 --process-outline=0 #{pdf_file_name} #{html_file_name}"
    Rails.logger.error `#{cmd}`
    html_content = File.read(html_file_name)
    render html: html_content.html_safe
    File.delete(html_file_name)
  end

  def html_file_name
    @_html_file_name ||= File.join Rails.root, (file_name + '.html')
  end

  def file_name
    SecureRandom.hex
  end
end
