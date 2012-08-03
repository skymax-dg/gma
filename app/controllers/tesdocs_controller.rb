#require 'spreadsheet'
#Spreadsheet.client_encoding = 'UTF-8'

require "prawn"
#require "prawn/layout"
require "prawn/measurement_extensions"
require 'will_paginate/array'

class TesdocsController < ApplicationController
before_filter :authenticate
  def index
    store_tipo_doc(params[:tipo_doc])
    init_filter(current_user.azienda)
  end

  def upload_xls
  end

  def addrow_fromxls
    tfile = params[:file]
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
            flash[:notice] = "CARICAMENTO COMPLETATO con SUCCESSO."
          else
            flash[:error] = "Si sono verificati ERRORI durante il caricamento (CARICAMENTO PARZIALE)"
          end
        rescue
          flash[:error] = $!.message
        end
      end
    rescue Exception => e
      flash[:error] = $!.message
      @errors << "File bloccato da un'altra applicazione o non trovato: " + e.to_s #$?.exitstatus
    end
  end

  def stp_ddt1
    @tesdoc   = Tesdoc.find(params[:id])
    @tit_doc = ["#{@tesdoc.causmag.descriz}", "(D.d.t.) D.P.R. 472 del 14-08-1996 - D.P.R. 696 del 21.12.1996"]
    @ana      = Anagen.find(current_user.azienda)
    @sl       = @ana.sedelegale
    @anad     = Anagen.find(@tesdoc.conto.anagen_id)
    @sld      = @anad.sedelegale
    @datispe  = @tesdoc.spediz
    @rifdoc   = {:nr => @tesdoc.num_doc, :dt => @tesdoc.data_doc}
    render 'stp_ddt1.pdf'
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
      redirect_to tesdoc, :notice => 'Righe documento cancellate con successo.'
    else
      redirect_to tesdoc, :notice => 'Errori in cancellazione Righe.'
    end
  end

  def ges_datisped
    tesdoc = Tesdoc.find(params[:id])
    if tesdoc.spediz
      redirect_to edit_spediz_path(:id => params[:id])
    else
      redirect_to new_spediz_path(:id => params[:id])
    end
  end

  def add1row4article
    tesdoc = Tesdoc.find(params[:id])
    if tesdoc.add1row4article(current_user.azienda)
      redirect_to tesdoc, :notice => 'Righe documento aggiunte con successo.'
    else
      redirect_to tesdoc, :notice => 'Errori in inserimento Righe.'
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
          #col_seguefatt =>
          #col_tipo_doc =>
          @errors, @success = Tesdoc.tesrigdocbyxls(book, sheet, rowini, coltes, colrig)
          if @errors.count == 0
            flash[:notice] = "CARICAMENTO COMPLETATO con SUCCESSO."
          else
            flash[:error] = "Si sono verificati ERRORI durante il caricamento (CARICAMENTO PARZIALE)"
          end
        rescue
          flash[:error] = $!.message
        end
      end
    rescue Exception => e
      flash[:error] = $!.message
      @errors << "File bloccato da un'altra applicazione o non trovato: " + e.to_s #$?.exitstatus
    end
  end

  def filter
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
    @tesdocs = Tesdoc.filter(@tpfilter, @desfilter,
                             [@clifilter, @forfilter, @altfilter],
                             se_tipo_doc,
                             @causmagfilter,
                             @contofilter,
                             current_user.azienda, current_annoese,
                             params[:page])
    render "index"
  end
  
  def new
    respond_to do |format|
      format.html do
        if params[:causmag].empty? or params[:causmag].nil? or params[:conto].empty? or params[:conto].nil?
          flash[:success] = "Per creare un nuovo DOC e' necessario prima impostare Causale e MastroContabile nei filtri e cliccare il bottone FILTRA"
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
        end
      end
      format.js
    end
  end

  def choose_tipo_doc
    clear_tipo_doc
  end

  def show
    @tesdoc = Tesdoc.find(params[:id])
    @rigdocs = @tesdoc.rigdocs.sort{|a,b|a.prgrig<=>b.prgrig}
    @rigdocs = @rigdocs.paginate(:page => params[:page], :per_page => 10)
    @subtot_iva = @tesdoc.subtot_iva
  end

  def edit
    @act_new = 0
    @tesdoc  = Tesdoc.find(params[:id])
    @causmag = Causmag.find(@tesdoc.causmag_id)
    @conto   = Conto.find(@tesdoc.conto_id)
  end

  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])
    if @tesdoc.save
      redirect_to @tesdoc, :notice => 'Testata documento inserita con successo.'
    else
      @causmag = Causmag.find(params[:tesdoc][:causmag_id])
      @conto = Conto.find(params[:tesdoc][:conto_id])
      @tesdoc.azienda = current_user.azienda
      @tesdoc.annoese = current_annoese
      @tesdoc.causmag_id = @causmag.id
      @tesdoc.conto_id = @conto.id
      @tesdoc.sconto = @conto.sconto
      flash[:error] = "Il salvataggio del documento non e' andato a buon fine"
      render 'new'
    end
  end

  def update
    @tesdoc = Tesdoc.find(params[:id])
    if @tesdoc.update_attributes(params[:tesdoc])
      redirect_to @tesdoc, :notice => 'Testata docuemnto aggiornata con successo.'
    else
      flash[:error] = "Il salvataggio del documento non e' andato a buon fine"
      render 'edit' 
    end
  end

  def destroy
    @tesdoc = Tesdoc.find(params[:id])
    @tesdoc.destroy
    flash[:notice] = "Cancellazione Eseguita"
    redirect_to tesdocs_url
  end
end
