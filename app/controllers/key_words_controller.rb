class KeyWordsController < ApplicationController
  # GET /key_words
  # GET /key_words.json
  def index
    @key_words = KeyWord.where(parent_id: nil)
    @title = "Key Words"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @key_words }
    end
  end

  # GET /key_words/1
  # GET /key_words/1.json
  def show
    @title = "Key Word"
    @key_word = KeyWord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @key_word }
    end
  end

  # GET /key_words/new
  # GET /key_words/new.json
  def new
    @title = "Nuova Key Word"
    @key_word = KeyWord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @key_word }
    end
  end

  # GET /key_words/1/edit
  def edit
    @title = "Modifica Key Word"
    @key_word = KeyWord.find(params[:id])
  end

  # POST /key_words
  # POST /key_words.json
  def create
    @key_word = KeyWord.new(params[:key_word])

    respond_to do |format|
      if @key_word.save
        format.html { redirect_to @key_word, notice: 'Key word was successfully created.' }
        format.json { render json: @key_word, status: :created, location: @key_word }
      else
        format.html { render action: "new" }
        format.json { render json: @key_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /key_words/1
  # PUT /key_words/1.json
  def update
    @key_word = KeyWord.find(params[:id])

    respond_to do |format|
      if @key_word.update_attributes(params[:key_word])
        format.html { redirect_to @key_word, notice: 'Key word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @key_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /key_words/1
  # DELETE /key_words/1.json
  def destroy
    @key_word = KeyWord.find(params[:id])
    @key_word.destroy

    respond_to do |format|
      format.html { redirect_to key_words_url }
      format.json { head :no_content }
    end
  end
end
