module Helper_pdf
  class CompanyPDFBase < Ruport::Formatter::PDF
    def prepare_std_report
      options.paper_size = "A4"
    end

    def build_company_header
      pdf_writer.select_font("Times-Roman") 
      options.text_format = { :font_size => 14, :justification => :right } 
      add_text "<i>" + Anagen.find(options.azienda).denomin + "</i>" 
      add_text "Creato alle #{Time.now.strftime('%H:%M del %d-%m-%Y')}" 
      move_cursor_to top_boundary - 80 
    end

    def finalize_std_report
      render_pdf
    end
  end
end
