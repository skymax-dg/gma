require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

class TesdocsController < ApplicationController
  def index
    store_tipo_doc(params[:tipo_doc])
    init_filter()
  end

  def delrowqta0
    tesdoc = Tesdoc.find(params[:id])
    Rigdoc.find_by_sql("SELECT * 
                          FROM rigdocs 
                         WHERE rigdocs.tesdoc_id = " + tesdoc.id.to_s + 
                         " AND rigdocs.qta = 0").each {|rigdoc| rigdoc.destroy}
    redirect_to tesdoc
  end

  def add1row4article
    tesdoc = Tesdoc.find(params[:id])
    newprg = tesdoc.lastprgrig + 1
    error = 0
    Article.azienda(StaticData::AZIENDA).find(:all).each do |art|
      @rigdoc = tesdoc.rigdocs.build
      @rigdoc.prgrig = newprg
      @rigdoc.article_id = art.id
      @rigdoc.descriz = art.descriz
      @rigdoc.qta = 0
      @rigdoc.sconto = tesdoc.sconto
      @rigdoc.prezzo = art.prezzo * (1 - @rigdoc.sconto / 100)
      newprg += 1
      if @rigdoc.save
#        redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
      else
        error = 1
#        flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
#        render 'new'
      end
    end
    if error == 1
      redirect_to tesdoc, :notice => 'Errori in inserimento Righe.'
    else
      redirect_to tesdoc, :notice => 'Righe documento aggiunte con successo.'
    end
  end

  def addtesrigdoc_fromxls
    begin
      @errors = []
      @success = []
      Spreadsheet.open "tesrigdocMESS.xls" do |book|
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
      @errors << "File bloccato da un'altra applicazione o non trovato: " + e #$?.exitstatus
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
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd and azienda = :azd", {:tpd => se_tipo_doc, :azd => StaticData::AZIENDA}])
    @contos = Conto.find4docfilter([@clifilter, @forfilter, @altfilter], @tpfilter||"", @desfilter||"")
    @tesdocs = Tesdoc.filter(@tpfilter, @desfilter,
                             [@clifilter, @forfilter, @altfilter],
                             se_tipo_doc,
                             @causmagfilter,
                             @contofilter,
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
          @tesdoc = Tesdoc.new
          @causmag = Causmag.find(params[:causmag])
          @conto = Conto.find(params[:conto])
          @tesdoc.azienda = StaticData::AZIENDA
          @tesdoc.annoese = StaticData::ANNOESE
          @tesdoc.causmag_id = @causmag.id
          @tesdoc.conto_id = @conto.id
          @tesdoc.sconto = @conto.sconto
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
    @rigdocs = @tesdoc.rigdocs.paginate(:page => params[:page], :per_page => 10)
    @rigdocs = @rigdocs.sort {|a,b|a.prgrig<=>b.prgrig}
  end

  def edit
    @tesdoc = Tesdoc.find(params[:id])
    @causmag = Causmag.find(@tesdoc.causmag_id)
    @conto = Conto.find(@tesdoc.conto_id)
  end

  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])
    if @tesdoc.save
      redirect_to @tesdoc, :notice => 'Testata documento inserita con successo.'
    else
      @causmag = Causmag.find(params[:tesdoc][:causmag_id])
      @conto = Conto.find(params[:tesdoc][:conto_id])
      @tesdoc.azienda = StaticData::AZIENDA
      @tesdoc.annoese = StaticData::ANNOESE
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
