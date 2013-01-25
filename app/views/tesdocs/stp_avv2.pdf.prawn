  pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  #titolo documento
  pdf.bounding_box [240,780], :width => 290, :height => 40 do
    pdf.stroke_bounds
  end
  pdf.text_box @tit_doc[0],
               :at => [250,770],  :width => 280, :height => 12, :size => 12, :style => :bold,
               :align => :center, :overflow => :shrink_to_fit, :min_font_size => 8
  pdf.text_box @tit_doc[1],
               :at => [250,760], :width => 280, :height => 24, :size => 8, :align => :center

  #Mittente
  # stampa logo immagine
  pdf.bounding_box [0,780], :width => 240, :height => 50 do
    pdf.image "#{Rails.root}/app/assets/images/logos/Eifis.jpg", :fit => [240,50]
  end
  # stampa logo cornice
  pdf.bounding_box [0,780], :width => 240, :height => 40 do
    pdf.stroke_bounds
  end

  pdf.bounding_box [0,780], :width => 240, :height => 155 do
    pdf.stroke_bounds
  end

  testo=""
  testo="Part.Iva: #{@ana.pariva}\n" if @ana.pariva && @ana.pariva.length > 0
  testo+="C.F.:#{@ana.codfis}\n" if testo == "" && @ana.codfis && @ana.codfis.length > 0
  testo+="Tel:#{@ana.telefono}" if @ana.telefono && @ana.telefono.length > 0
  testo+=" / " if @ana.telefono && @ana.fax && @ana.telefono.length > 0 && @ana.fax.length > 0
  testo+="Fax:#{@ana.fax}" if @ana.fax && @ana.fax.length > 0
  testo+="\n"
  testo+="EMail:#{@ana.email}" if @ana.email && @ana.email.length > 0
  testo+=" / " if @ana.email && @ana.web && @ana.email.length > 0 && @ana.web.length > 0
  testo+="Web:#{@ana.web}" if @ana.web && @ana.web.length > 0
  pdf.formatted_text_box [{:text => "#{@ana.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sl[:indir]}\n#{@sl[:desloc]}\n"},
                          {:text => testo}],
                         :at => [2,720], :width => 238, :height => 130,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6

  #Destinatario
  pdf.formatted_text_box [{:text => "Cervia, #{to_mydate(Date.today)}\n", :styles => [:bold], :size => 12},
                          {:text => "\nSpett.le\n", :styles => [:bold], :size => 12},
                          {:text => "G L S  -  Ravenna\n", :styles => [:bold], :size => 12},
                          {:text => "\nfax: 0544 - 450389"}],
                           :at => [242,698], :width => 286, :height => 92,
                           :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  #Destinatario
  pdf.bounding_box [240,740], :width => 290, :height => 135 do
    pdf.stroke_bounds
  end

  #Riferimenti documento
  pdf.bounding_box [0,625], :width => 240, :height => 20 do
    pdf.stroke_bounds
  end

  testo = "DOC. Nr. #{@rifdoc[:nr].to_s.rjust(5, '0')}"
  testo+= "/#{@tesdoc.causmag.sfx.strip}" if @tesdoc.causmag.sfx && @tesdoc.causmag.sfx.strip.length > 0
  testo+= "/#{@tesdoc.annoese} del #{@rifdoc[:dt].strftime("%d/%m/%Y")}"

  pdf.text_box "#{testo}",
               :at => [2, 619], :width => 240, :height => 15, :size => 12, :style => :bold


  pdf.formatted_text_box [{:text => "OGGETTO: ", :styles => [:bold]},
                          {:text => "Autorizzazione al ritiro per ns/conto ed al seguente indirizzo, di quanto segue:", :size => 14, :styles => [:bold]}],
                          :at => [2, 590], :width => 570, :height => 60, :size => 10
  pdf.move_down 10

  testo=""
  testo="Part.Iva: #{@anad.pariva}\n" if @anad.pariva && @anad.pariva.length > 0
  testo+="C.F.:#{@anad.codfis} " if testo == "" && @anad.codfis && @anad.codfis.length > 0
  testo+="Tel:#{@anad.telefono} " if @anad.telefono && @anad.telefono.length > 0
  testo+="EMail:#{@anad.email} " if @anad.email && @anad.email.length > 0
  testo+="/ " if @anad.email && @anad.web && @anad.email.length > 0 && @anad.web.length > 0
  testo+="Web:#{@anad.web}" if @anad.web && @anad.web.length > 0
  @referente="C.A. Sig. #{@tesdoc.conto.anagen.referente}" if @tesdoc.conto.anagen.referente&&(not @tesdoc.conto.anagen.referente.blank?)
  @referente ? testoref="\n\n#{@referente}" : testoref=""
  pdf.formatted_text_box [{:text => "#{@anad.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sld[:indir]}\n#{@sld[:desloc]}\n"},
                          {:text => testo},
                          {:text => testoref, :styles => [:bold]}],
                         :at => [20,540], :width => 400, :height => 120,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  pdf.move_down 150

  if @datispe
    testo=""
    testo+="Data del ritiro: #{@datispe.dtrit.strftime('%d/%m/%Y')} " if @datispe.dtrit
    testo+="dalle ore #{@datispe.orarit.strftime('%H:%M')}" if @datispe.orarit.strftime('%H:%M')!="00:00"
    testo+="\nColli: nr. #{@datispe.nrcolli} " if @datispe.nrcolli
    testo+="(#{Spediz::UM[@datispe.um]}: #{@datispe.valore})" if @datispe.valore&&@datispe.um
    testo+="\n Trasporto a ns/carico\n\n\n"
    pdf.text testo, :size => 14, :style => :bold

    testo="\n Destinatario: #{@ana.denomin}"
    pdf.text testo, :size => 14, :style => :bold

    pdf.draw_text @sl[:indir], :size => 14, :style => :bold, :at => [100, 310]
    pdf.draw_text @sl[:desloc], :size => 14, :style => :bold, :at => [100, 290]

    if @datispe.note.nil? || @datispe.note.blank?
      #Esegue salto pagina se non è rimasto abbastanza spazio per i finali
      if pdf.cursor < 180
        pdf.start_new_page
        render :partial=>'testafatt.pdf.prawn', :locals=>{:pdf=>pdf}
      end
    else
      #Esegue salto pagina se non è rimasto abbastanza spazio per le note
      if pdf.cursor < 350
        pdf.start_new_page
        render :partial=>'testafatt.pdf.prawn', :locals=>{:pdf=>pdf}
      end
      #note
      pdf.text_box "Annotazioni: #{@datispe.note}",
                   :at => [2, 178], :width => 80, :height => 12, :size => 10 if @datispe&&@datispe.note
    end
  end
  pdf.move_down 50
  testo="\n\nVi ringraziamo della cortese collaborazione.\nCordialmente.\n#{Anagen.find(@tesdoc.azienda).denomin}\n"
  pdf.text testo, :size => 10

  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
