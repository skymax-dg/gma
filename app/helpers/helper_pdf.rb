module Helper_pdf
  def main_pdf_header
    pdf_writer.select_font("Times-Roman") 
    options.text_format = { :font_size => 14, :justification => :right } 
    add_text "<i>" + Anagen.find(StaticData::ANARIF).denomin + "</i>" 
    add_text "Creato alle #{Time.now.strftime('%H:%M del %d-%m-%Y')}" 
    move_cursor_to top_boundary - 80 
  end
end
