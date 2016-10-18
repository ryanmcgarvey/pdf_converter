require 'securerandom'
class PdfController < ApplicationController
  def create
    if params[:pdf_content].is_a? String
      pdf_file_name = File.join "tmp", (file_name + '.pdf')
      log "Creating #{pdf_file_name}"
      file = File.new(pdf_file_name, 'w+')
      file.write(params[:pdf_content])
      file.close
      execute(file.path)
      # File.delete(pdf_file_name)
    else
      execute(params[:pdf_content].tempfile.path)
    end
  end

  private

  def execute(pdf_file_name)
    log "Converting #{pdf_file_name}"
    cmd = "(cd #{Rails.root}; pdf2htmlEX --data-dir #{data_dir} --printing=0 --process-outline=0 #{pdf_file_name} #{html_file_name} 2>&1)"
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
    @_html_file_name ||= File.join "tmp", (file_name + '.html')
  end

  def data_dir
    File.join Rails.root, "pdf2htmlex_config"
  end

  def file_name
    @_file_name ||= SecureRandom.hex[0..8]
  end
end
