require 'securerandom'
class PdfController < ApplicationController
  def create
    if params[:pdf_content].is_a? String
      log `cd #{Rails.root}`
      log `pwd`
      pdf_file_name = File.join Rails.root, "documents", (file_name + '.pdf')
      log "Creating #{pdf_file_name}"
      file = File.new(pdf_file_name, 'w+')
      file.write(params[:pdf_content])
      execute(file.path)
      file.close
      # Rails.logger.error `rm #{pdf_file_name}`
    else
      execute(params[:pdf_content].tempfile.path)
    end
  end

  private

  def execute(pdf_file_name)
    log "Converting #{pdf_file_name}"
    cmd = "cd #{Rails.root}; pdf2htmlEX --data-dir pdf2htmlex_config --printing=0 --process-outline=0 #{pdf_file_name} #{html_file_name}"
    log cmd
    log `#{cmd}`
    html_content = File.read(html_file_name)
    log "Rendered #{html_file_name}: #{html_content.size} bytes"
    render html: html_content.html_safe
    # File.delete(html_file_name)
  end

  def log(str)
    Rails.logger.error str
  end

  def html_file_name
    @_html_file_name ||= File.join Rails.root, "documents", (file_name + '.html')
  end

  def file_name
    @_file_name ||= SecureRandom.hex
  end
end
