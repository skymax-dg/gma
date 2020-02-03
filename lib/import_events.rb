require 'csv'

class ImportEvent

  def self.process(fp)
    if File.exists?(fp) && File.extname(fp).downcase == ".csv"
      self.import(fp)
    else
      return [-1, "Errore file non valido"]
    end
  end

  def self.import(fp)
    n = 0
    t = 0
    errs = []
    CSV.foreach(fp, headers: true, header_converters: :symbol, col_sep: ";") do |row|
      st, err = make_event(row.to_hash)
      if st > 0
        n += 1 
      else
        errs << "Riga %d: %s"%[t+2, err]
      end
      t += 1
    end

    self.report_process(n, t, errs)
  end

  # 1 -> OK
  # -1 -> articolo non trovato
  # -2 -> errore creazione record
  def self.make_event(h)
    art = Article.where(codice: h[:codice_articolo]).first
    if art
      teach = Anagen.where(codice: h[:codice_insegnante]).first
      locat = Anagen.where(codice: h[:codice_sede]).first
      durat = self.decode_duration(h)

      event = Event.create( description: h[:descrizione], article: art, timetable: h[:timeline], dt_event: h[:dt1], dt_event2: h[:dt2], dt_event3: h[:dt3], dt_event4: h[:dt4], duration: durat, site_anagen: locat, dressing: h[:abbigliamento])
      if event.errors.any?
        [-2, "Errore creazione: %s"%[event.errors.full_messages]]
      else
        EventState.create(event: event, anagen: teach, mode: EventState::TEACHER) if teach
        [1, ""]
      end
    else
      return [-1, "Codice articolo non valido"]
    end
  end

  def self.decode_duration(h)
    num = 0
    [:dt1, :dt2, :dt3, :dt4].each { |k| num += 1 if h[k] }
    num
  end

  def self.report_process(n, t, errs)
    puts "-"*10
    puts "Caricamento completato:"
    puts "Eventi importati: %d/%d"%[n, t]
    puts "Errori:"
    if errs.size > 0
      errs.each { |e| puts e }
    end
  end
end
