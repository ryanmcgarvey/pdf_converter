require 'securerandom'
class PdfController < ApplicationController
  def create
    if params[:pdf_content].is_a? String
      pdf_file_name = file_name + '.pdf'
      file = File.new(pdf_file_name, 'w+')
      file.write(params[:pdf_content])
      execute(file.path)
      File.delete(file)
    else
      execute(params[:pdf_content].tempfile.path)
    end
  end

  def from_content
    pdf_content = params[:pdf_content]
    pdf_file_name = SecureRandom.hex + '.html'
    execute(pdf_file_name)
  end

  private

  def execute(pdf_file_name)
    cmd = "pdf2htmlEx --data-dir pdf2htmlex_config --printing=0 --process-outline=0 #{pdf_file_name} #{html_file_name}"
    Rails.logger.error `#{cmd}`
    html_content = File.read(html_file_name)
    render html: html_content.html_safe
    File.delete(html_file_name)
  end

  def html_file_name
    @_html_file_name ||= file_name + '.html'
  end

  def file_name
    SecureRandom.hex
  end
end
