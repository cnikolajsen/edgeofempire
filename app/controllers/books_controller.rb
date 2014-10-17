class BooksController < InheritedResources::Base
  before_filter :set_book
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_filter :set_page
  load_and_authorize_resource

  def index
    @book = Book.where(:true).order(:title)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @book }
    end
  end

  def show
    @title = "#{@book.title} | #{@title}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: "#{@book.title} was successfully created." }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice:  "#{@book.title} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:title, :description, :system, :isbn, :ffg_sku,
                                 :category, :cover_art_url)
  end

  def set_page
    @page = 'books'
    @parent_page = 'misc'
  end
end