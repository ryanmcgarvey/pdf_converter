require 'securerandom'
class Converter < Struct.new(:pdf_file_name)

  # attr_reader :html_file_name, :pdf_file_name, :html_full_path
  # def initialize(pdf_file_name, html_file_name: generate_html_file_name, html_full_path: generate_full_path)
    # html_file
  # end

  def self.from_string(string)
    pdf_file_name = File.join Rails.root, "tmp", (file_name + '.pdf')
    log "Creating #{pdf_file_name}"
    file = File.new(pdf_file_name, 'w+')
    file.write(string)
    content = new(file.path).execute
    file.close
    File.delete(pdf_file_name)
    content
  end

  def execute(data_dir: File.join(Rails.root, "pdf2htmlex_config"), max_width: 720, max_height: 405, format: 'jpg')
    log "Converting #{pdf_file_name}"

    ex %|gs -sDEVICE=pdfwrite -sOutputFile='#{pdf_file_name}.opt' -dNOPAUSE -dBATCH #{pdf_file_name}|
    ex %|(cd #{Rails.root}; pdf2htmlEX --data-dir #{data_dir} --optimize-text=0 --printing=0 --fallback=1 --process-outline=0 --bg-format=#{format} --fit-width=#{max_width} --fit-height=#{max_height} #{pdf_file_name}.opt #{html_file_name} 2>&1)|

    html_content = File.read(html_full_path)
    log "Rendered #{html_file_name}: #{html_content.size} bytes"
    File.delete(html_full_path)
    html_content
  end

  def log(str)
    puts str
    Rails.logger.error str
  end

  def self.log(str)
    puts str
    Rails.logger.error str
  end

  def ex(cmd)
    log cmd
    log `#{cmd}`
  end

  def html_full_path
    puts File.join Rails.root, html_file_name
    File.join Rails.root, html_file_name
  end

  def html_file_name
    @_html_file_name ||= File.join "tmp", (self.class.file_name + '.html')
  end

  def self.file_name
    SecureRandom.hex[0..8]
  end

end
