require 'securerandom'
class PdfsController < ApplicationController
  def create
    file_name = SecureRandom.hex
    pdf_file_name = file_name + '.pdf'
    html_file_name = file_name + '.html'
    pdf_content = params[:file]

    pdf_file = File.open(pdf_file_name, 'w+')
    pdf_file.write pdf_content

    output = `pdf2htmlex #{pdf_file_name} --data-dir converter/config --printing=0 --process-outline=0`

    html_content = File.read(html_file_name)

    render text: html_content

    File.delete(html_file_name)
    File.delete(pdf_file_name)
  end
end
