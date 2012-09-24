require "prawn"
#require "prawn/layout"
require "prawn/measurement_extensions"
require 'will_paginate/array'

class TesdocsController < ApplicationController
before_filter :authenticate

  def upload_xls
    @title = "SCELTA FILE XLS PER CARICAMENTO RIGHE DOCUMENTO"
    @tesdoc = Tesdoc.find(params[:id])
  end

  def index
    store_tipo_doc(params[:tipo_doc])
store_location
    @title = "Elenco Documenti (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
    init_filter(current_user.azienda)
  end

  def addrow_fromxls
    tfile = params[:file]

    if tfile.nil?
      flash[:alert] = "File non specificato o non disponibile"
      redirect_to upload_xls_tesdoc_path(:id => params[:id]) and return
    end
    @title = "REPORT caricamento automatico:"
    time=Time.now()
    str="_#{time.year.to_s}_#{time.month.to_s}_#{time.day.to_s}_#{time.hour.to_s}_#{time.min.to_s}_#{time.sec.to_s}.xls"
    tname = tfile.original_filename.gsub(".xls", str)
    # create the file path
    path = File.join("#{Rails.root}/public/upload", "#{tname}")
    # write the file
    File.open(path, "wb") { |f| f.write(tfile.read) }
    begin
      @errors = []
      @success = []
      Spreadsheet.open path do |book|
        @tesdoc = Tesdoc.find(params[:id])
        begin
          @errors = Article.chk_art_xls(current_user.azienda, book, 0, 1, 0)
          raise "I seguenti articoli non sono presenti sulla banca dati" if @errors.count > 0
          @errors, @success = @tesdoc.rigdocbyxls(book, 0, 1, {:article_id_bycod => 0, :qta => 1, :prezzo => 2, :sconto => 3})
          if @errors.count == 0
            flash.now[:success] = "CARICAMENTO COMPLETATO con SUCCESSO."
          else
            flash.now[:alert] = "Si sono verificati ERRORI durante il caricamento (CARICAMENTO PARZIALE)"
          end
        rescue
          flash.now[:alert] = $!.message
        end
      end
    rescue Exception => e
      flash.now[:alert] = $!.message
      @errors << "File bloccato da un'altra applicazione o non trovato: #{e.to_s}" #$?.exitstatus
    end
  end

  def dati_ind
    @title = "Stampa Indirizzi"
    @tesdoc = Tesdoc.find(params[:id])

    @tesdoc.spediz&&@tesdoc.spediz.presso&&(not @tesdoc.spediz.presso.blank?) ? @presso = @tesdoc.spediz.presso : @presso = @tesdoc.conto.anagen.denomin
    @tesdoc.spediz ? @ind1 = @tesdoc.spediz.dest1 : @ind1 = ""
    @tesdoc.spediz ? @ind2 = @tesdoc.spediz.dest2 : @ind2 = ""
    @tesdoc.conto.anagen.telefono ? @riftel = @tesdoc.conto.anagen.telefono : @riftel = ""
    @tesdoc.spediz ? @copie = @tesdoc.spediz.nrcolli.to_i : @copie = 1
    @nrcopie = 'S'
  end

  def stp_ind
    @presso = params[:presso]
    @ind1 = params[:ind1]
    @ind2 = params[:ind2]
    @riftel = params[:riftel]
    @copie = params[:copie].to_i
    @nrcopie = params[:nrcopie]
    render 'stp_ind.pdf'
  end

  def stp
    @tesdoc   = Tesdoc.find(params[:id])
    @tit_doc  = []

    @tit_doc[0] = "#{@tesdoc.causmag.des_caus}"
    @tit_doc[1] = ""
    @ana      = Anagen.find(current_user.azienda)
    @sl       = @ana.sedelegale
    @anad     = Anagen.find(@tesdoc.conto.anagen_id)
    @sld      = @anad.sedelegale
    @rifdoc   = {:nr => @tesdoc.num_doc, :dt => @tesdoc.data_doc}

    @datispe  = @tesdoc.spediz unless @tesdoc.spediz.nil?
    if @tesdoc.movmagint && @tesdoc.spediz.nil?
      flash[:alert] = "DATI DI SPEDIZIONE MANCANTI"
      redirect_to @tesdoc
    elsif @tesdoc.causmag.modulo == "DDT"
      @tit_doc[1] = "(D.d.t.) D.P.R. 472 del 14-08-1996 - D.P.R. 696 del 21.12.1996"
      @datispe  = @tesdoc.spediz
      render 'stp_ddt1.pdf'
    elsif @tesdoc.causmag.modulo == "NOTACRE"
      render 'stp_fat1.pdf'
    elsif @tesdoc.causmag.modulo == "FATT"
      render 'stp_fat1.pdf'
    elsif @tesdoc.causmag.modulo == "FATTACC"
      render 'stp_fat1.pdf'
    elsif @tesdoc.causmag.modulo == "ORD"
      flash[:alert] = "MODULO DI STRAMPA NON TROVATO !!! (#{@tesdoc.causmag.modulo})"
      redirect_to @tesdoc
    elsif @tesdoc.causmag.modulo == "PREV"
      flash[:alert] = "MODULO DI STRAMPA NON TROVATO !!! (#{@tesdoc.causmag.modulo})"
      redirect_to @tesdoc
    elsif @tesdoc.causmag.modulo == "TRASF"
      flash[:alert] = "MODULO DI STRAMPA NON TROVATO !!! (#{@tesdoc.causmag.modulo})"
      redirect_to @tesdoc
    end
  end

  def stp_ddt1
    @tesdoc   = Tesdoc.find(params[:id])
    if @tesdoc.movmagint
      @tit_doc = ["#{@tesdoc.causmag.des_caus}", "(D.d.t.) D.P.R. 472 del 14-08-1996 - D.P.R. 696 del 21.12.1996"]
      @ana      = Anagen.find(current_user.azienda)
      @sl       = @ana.sedelegale
      @anad     = Anagen.find(@tesdoc.conto.anagen_id)
      @sld      = @anad.sedelegale
      @datispe  = @tesdoc.spediz
      @rifdoc   = {:nr => @tesdoc.num_doc, :dt => @tesdoc.data_doc}
      render 'stp_ddt1.pdf'
    else
      flash[:alert] = "STAMPA DDT FALLITA !!! -- Il Documento non movimenta il magazzino"
      redirect_to @tesdoc
    end
  end

  def stp_fat1
    @tesdoc   = Tesdoc.find(params[:id])
    @tit_doc = ["#{@tesdoc.causmag.descriz}", ""]
    @ana      = Anagen.find(current_user.azienda)
    @sl       = @ana.sedelegale
    @anad     = Anagen.find(@tesdoc.conto.anagen_id)
    @sld      = @anad.sedelegale
    @datispe  = @tesdoc.spediz
    @rifdoc   = {:nr => @tesdoc.num_doc, :dt => @tesdoc.data_doc}
    render 'stp_fat1.pdf'
  end

  def delrowqta0
    tesdoc = Tesdoc.find(params[:id])
    if tesdoc.delrowqta0
      flash[:success] = "Righe documento cancellate con successo."
      redirect_to tesdoc
    else
      flash[:alert] = "Errori in cancellazione Righe."
      redirect_to tesdoc
    end
  end

  def ges_datisped
    @tesdoc = Tesdoc.find(params[:id])
    if @tesdoc.movmagint || @tesdoc.causmag.contabile == "S"
      if @tesdoc.spediz
        redirect_to edit_spediz_path(:id => params[:id])
      else
        redirect_to new_spediz_path(:id => params[:id])
      end
    else
      flash[:alert] = "La causale del Documento non e' di tipo contabile e non movimenta il magazzino, 
                       dati spedizione/pagamento non necessari"
      redirect_to @tesdoc
    end
  end

  def add1row4article
    tesdoc = Tesdoc.find(params[:id])
    if tesdoc.add1row4article(current_user.azienda)
      flash[:success] = "Righe documento aggiunte con successo."
      redirect_to tesdoc
    else
      flash[:alert] = "Errori in inserimento Righe."
      redirect_to tesdoc
    end
  end

  def addtesrigdoc_fromxls
    begin
      @errors = []
      @success = []
      Spreadsheet.open "tesrigdoc.xls" do |book|
        begin
          #@errors = Tesdoc.chk_tesrigdoc_xls(book, ...)
          #raise "Errore su alcune testate e righe documento" if @errors.count > 0
          rowini = 3
          sheet = 0
          coltes = {:col_azienda      => 0, :col_annoese  => 1,  :col_num_doc => 3,
                    :col_data_doc     => 4, :col_descriz  => 5,  :col_causmag_id => 2,
                    :col_conto_codice => 7, :col_nrmagsrc => 9, :col_nrmagdst => 10}
          colrig = {:col_article_codice => 11, :col_descriz => 14, :col_qta => 15,
                    :col_prezzo         => 12, :col_prgrig  => 8}
          #col_sconto => 0
          @errors, @success = Tesdoc.tesrigdocbyxls(book, sheet, rowini, coltes, colrig)
          if @errors.count == 0
            flash.now[:success] = "CARICAMENTO COMPLETATO con SUCCESSO."
          else
            flash.now[:alert] = "Si sono verificati ERRORI durante il caricamento (CARICAMENTO PARZIALE)"
          end
        rescue
          flash.now[:alert] = $!.message
        end
      end
    rescue Exception => e
      flash.now[:alert] = $!.message
      @errors << "File bloccato da un'altra applicazione o non trovato: #{e.to_s}" #$?.exitstatus
    end
  end

  def filter
    @title = "Elenco Documenti (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @clifilter = params[:clifilter]
    @forfilter = params[:forfilter]
    @altfilter = params[:altfilter]
    @causmagfilter = params[:causmagfilter]
    @contofilter = params[:contofilter]
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd and azienda = :azd", 
                                  {:tpd => se_tipo_doc, :azd => current_user.azienda}])
    @contos = Conto.find4docfilter([@clifilter,     @forfilter,           @altfilter], @tpfilter||"",
                                    @desfilter||"", current_user.azienda, current_annoese)
    @tesdocs, nrrecord = Tesdoc.filter(@tpfilter, @desfilter,
                                      [@clifilter, @forfilter, @altfilter],
                                       se_tipo_doc,
                                       @causmagfilter,
                                       @contofilter,
                                       current_user.azienda, current_annoese,
                                       params[:page])
    flash_cnt(nrrecord) if params[:page].nil?
store_location

    render "index"
  end
  
  def new
    @title = "Nuovo Documento (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
    respond_to do |format|
      format.html do
        if params[:causmag].empty? or params[:causmag].nil? or params[:conto].empty? or params[:conto].nil?
          flash.now[:success] = "Per creare un nuovo DOC e' necessario prima impostare Causale e 
                                 MastroContabile nei filtri e cliccare il bottone FILTRA"
          init_filter
          render "index"
        else
          @act_new = 1
          @tesdoc = Tesdoc.new
          @causmag = Causmag.find(params[:causmag])
          @conto = Conto.find(params[:conto])
          @tesdoc.azienda = current_user.azienda
          @tesdoc.annoese = current_annoese
          @tesdoc.causmag_id = @causmag.id
          @tesdoc.descriz = @causmag.descriz
          @tesdoc.conto_id = @conto.id
          @tesdoc.sconto = @conto.sconto
          @tesdoc.tipo_doc = @causmag.tipo_doc
          @tesdoc.num_doc = Tesdoc.new_num_doc(@tesdoc.tipo_doc, @tesdoc.annoese, @tesdoc.azienda)
          @spediz = @tesdoc.build_spediz # La Build valorizza automaticamente il campo spediz.tesdoc_id
        end
      end
      format.js
    end
  end

  def show
    @title = "Mostra Documento (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
    @tesdoc = Tesdoc.find(params[:id])
    @spediz = @tesdoc.spediz
    @page = params[:page]
    @rigdocs = @tesdoc.rigdocs.sort{|a,b|a.prgrig<=>b.prgrig}
    @rigdocs = @rigdocs.paginate(:page => @page, :per_page => 10)
    @subtot_iva = @tesdoc.subtot_iva
  end

  def edit
    @title = "Modifica Testata documento (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
    @act_new = 0
    @tesdoc  = Tesdoc.find(params[:id])
    @spediz = @tesdoc.spediz
    @causmag = Causmag.find(@tesdoc.causmag_id)
    @conto   = Conto.find(@tesdoc.conto_id)
  end

  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])
    if @tesdoc.save
      flash[:success] = "Testata documento inserita con successo."
      redirect_to @tesdoc
    else
      @title = "Nuovo Documento (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
      @causmag = Causmag.find(params[:tesdoc][:causmag_id])
      @conto = Conto.find(params[:tesdoc][:conto_id])
      @tesdoc.azienda = current_user.azienda
      @tesdoc.annoese = current_annoese
      @tesdoc.causmag_id = @causmag.id
      @tesdoc.conto_id = @conto.id
      @tesdoc.sconto = @conto.sconto
#      flash.now[:alert] = "Il salvataggio del documento non e' andato a buon fine"
      render 'new'
    end
  end

  def update
    @tesdoc = Tesdoc.find(params[:id])
    if @tesdoc.update_attributes(params[:tesdoc])
      flash[:success] = "Testata documento aggiornata con successo."
      redirect_to @tesdoc
    else
      @title = "Modifica Testata documento (#{Causmag::TIPO_DOC[se_tipo_doc.to_i]})"
#      flash.now[:alert] = "Il salvataggio del documento non e' andato a buon fine"
      render 'edit' 
    end
  end

  def destroy
    @tesdoc = Tesdoc.find(params[:id])

    begin
      @tesdoc.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
redirect_back_or @tesdoc
  end
end
