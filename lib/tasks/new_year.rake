# 
# rake new_year:import_conti file=percorso/nome_file.xls
#
#  0  id
#  1  azienda
#  2  annoese
#  3  codice
#  4  descriz
#  5  tipoconto
#  6  cntrpartita
#  7  sconto
#  8  data_creaz
#  9  data_modif
#  10 anagen_id
#  11 tipopeo
#
#
namespace :new_year do

  def get_fn( prompt, fn)
    while !fn || !File.exists?( fn ) do
       fn = Readline.readline(prompt + " > ")
    end
    fn
  end

  def get_int( prompt, vmin, vmax, v)

    while !v || v < vmin || v > vmax do
       v = Readline.readline(prompt + " > ").to_i
    end
    v
  end

  desc "importazione conti"
  task :import_conti => [:environment] do

    fn = get_fn( "Nome file excel con conti?", ENV['file'])

    anno = get_int( "anno da iniziare", 2012, 2099, nil)

    conferma = Readline.readline("Confermare importazione conti da file %s per iniziare anno %d? [S/s-N/n]"%[fn, anno])
    if conferma.downcase != 's'
      abort "Operazione annullata dall'utente"
    end

    m_safe = (Readline.readline("elaboro senza salvare [S/s-N/n]").downcase == 's')

    # Eliminazione dei dev_types attualmente presenti
    #conferma = Readline.readline("Confermare eliminazione dev_types ? [S/s-N/n]")
    #if conferma.downcase == 's'
    #  DevType.destroy_all
    #end

    # apro il file excel
    book = Spreadsheet.open(fn)
    sheet = book.worksheet 0

    # leggo le righe 
    conta = 0
    sheet.each 1 do |row|
      if row[2].to_i == anno-1
        puts row[1], row[2], row[3]
        conta += 1
        unless m_safe
          Conto.create( 
            :azienda => row[1].to_i, 
            :annoese => anno, 
            :codice => row[3].to_i,
            :descriz => row[4],
            :tipoconto => row[5],
            :cntrpartita => row[6].to_i,
            :sconto => row[7].to_f,
            :anagen_id => row[10].to_i,
            :tipopeo => row[11]
          )
        end
      end
    end

    puts "conti inseriti %d"%[conta]
  end

  desc "duplicazione conti"
  task :clone_conti => [:environment] do


    anno = get_int( "anno da iniziare", 2012, 2099, nil)

    conferma = Readline.readline("Confermare importazione conti da anno  %d per iniziare anno %d? [S/s-N/n]"%[anno-1, anno])
    if conferma.downcase != 's'
      abort "Operazione annullata dall'utente"
    end

    m_safe = (Readline.readline("elaboro senza salvare [S/s-N/n]").downcase == 's')

    # salvo i dati dell'anno precedente
    contos = []
    Conto.where(:annoese => anno-1).each do |co|
      contos << { 
        :azienda => co.azienda ,
        :annoese => co.annoese ,
        :codice => co.codice ,
        :descriz => co.descriz ,
        :tipoconto => co.tipoconto ,
        :cntrpartita => co.cntrpartita ,
        :sconto => co.sconto ,
        :anagen_id => co.anagen_id ,
        :tipopeo => co.tipopeo 
      }
    end
    puts "conti letti %d"%[contos.count]

    # creo i nuovi conti
    conta = 0
    contos.each do |row|
      puts row.codice, row.descriz
      conta += 1
      unless m_safe
          Conto.create( 
            :azienda => row.azienda, 
            :annoese => anno, 
            :codice => row.codice,
            :descriz => row.descriz,
            :tipoconto => row.tipoconto,
            :cntrpartita => row.cntrpartita,
            :sconto => row.sconto,
            :anagen_id => row.anagen_id,
            :tipopeo => row.tipopeo
          )
        end
      end
    end

    puts "conti inseriti %d"%[conta]
  end

end
