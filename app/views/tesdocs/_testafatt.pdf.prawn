  #titolo documento
  ppdf.bounding_box [240,780], :width => 290, :height => 40 do
    ppdf.stroke_bounds
  end
  ppdf.text_box @tit_doc[0],
               :at => [250,770],  :width => 280, :height => 12, :size => 12, :style => :bold,
               :align => :center, :overflow => :shrink_to_fit, :min_font_size => 8
  ppdf.text_box @tit_doc[1],
               :at => [250,760], :width => 280, :height => 24, :size => 8, :align => :center

  #Mittente
  # stampa logo immagine
  ppdf.bounding_box [0,780], :width => 240, :height => 50 do
    ppdf.image "#{Rails.root}/app/assets/images/logos/Eifis.jpg", :fit => [240,50]
  end
  # stampa logo cornice
  ppdf.bounding_box [0,780], :width => 240, :height => 40 do
    ppdf.stroke_bounds
  end

  ppdf.bounding_box [0,780], :width => 240, :height => 155 do
    ppdf.stroke_bounds
  end

  testo=""
  testo="Part.Iva: #{@ana.pariva}\n" if @ana.pariva && @ana.pariva.length > 0
  testo+="C.F.:#{@ana.codfis}\n" if testo == "" && @ana.codfis.length > 0
  testo+="Tel:#{@ana.telefono}" if @ana.telefono && @ana.telefono.length > 0
  testo+=" / " if @ana.telefono && @ana.fax && @ana.telefono.length > 0 && @ana.fax.length > 0
  testo+="Fax:#{@ana.fax}" if @ana.fax && @ana.fax.length > 0
  testo+="\n"
  testo+="EMail:#{@ana.email}" if @ana.email && @ana.email.length > 0
  testo+=" / " if @ana.email && @ana.web && @ana.email.length > 0 && @ana.web.length > 0
  testo+="Web:#{@ana.web}" if @ana.web && @ana.web.length > 0
  ppdf.formatted_text_box [{:text => "#{@ana.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sl[:indir]}\n#{@sl[:cap]} #{@sl[:desloc]}\n"},
                          {:text => testo}],
                         :at => [2,720], :width => 238, :height => 130,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6

  #Destinatario
  ppdf.bounding_box [240,740], :width => 290, :height => 135 do
    ppdf.stroke_bounds
  end

  testo=""
  testo="Part.Iva: #{@anad.pariva}\n" if @anad.pariva && @anad.pariva.length > 0
  testo+="C.F.:#{@anad.codfis} " if testo == "" && @anad.codfis.length > 0
  testo+="Tel:#{@anad.telefono} " if @anad.telefono && @anad.telefono.length > 0
  testo+="EMail:#{@anad.email} " if @anad.email && @anad.email.length > 0
  testo+="/ " if @anad.email && @anad.web && @anad.email.length > 0 && @anad.web.length > 0
  testo+="Web:#{@anad.web}" if @anad.web && @anad.web.length > 0
  ppdf.formatted_text_box [{:text => "Spett.le: #{@anad.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sld[:indir]}\n#{@sld[:cap]} #{@sld[:desloc]}\n"},
{:text => testo}
],
                         :at => [242,698], :width => 286, :height => 92,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  #Riferimenti documento
  ppdf.bounding_box [0,625], :width => 240, :height => 20 do
    ppdf.stroke_bounds
  end
  ppdf.text_box "DOCUM.Nr. #{@rifdoc[:nr]}/#{@rifdoc[:dt].strftime("%Y")} del #{@rifdoc[:dt].strftime("%d/%m/%Y")}",
               :at => [2, 619], :width => 240, :height => 15, :size => 12, :style => :bold

  if @ddt == 1
    ppdf.bounding_box [0,605], :width => 530, :height => 30 do
      ppdf.stroke_bounds
    end
    ppdf.formatted_text_box [{:text => "Causale di trasporto: ", :styles => [:bold]},
                            {:text => @tesdoc.causmag.caus_tra||""}],
                             :at => [2, 590], :width => 280, :height => 20, :size => 10
#                             :at => [2, 565], :width => 240, :height => 20, :size => 10
    ppdf.formatted_text_box [{:text => "A mezzo: ", :styles => [:bold]},
                            {:text => Spediz::CORRIERE[(@datispe&&@datispe.corriere)||""]||""}],
                             :at => [270, 590], :width => 260, :height => 45, :size => 10
#                             :at => [270, 565], :width => 260, :height => 45, :size => 10
  end
  ppdf.move_down 10
