require 'sqlite3'

class CalibreBook
  def self.connect(path_to_calibre_db)
    @@calibre_path = path_to_calibre_db
    @@db = SQLite3::Database.new "#{@@calibre_path}/metadata.db"
    ## Find pagecount custom column
    @@pagecount_column = nil
    begin
      @@pagecount_column = @@db.execute("select id from custom_columns where label = 'pagecount'").first.first
    rescue
    end
  end

  def self.all_books()
    @@db.execute("select id from books").flatten.map{|book_id| CalibreBook.new(book_id)}
  end

  def self.some_books(limit=10)
    @@db.execute("select id from books limit #{limit}").flatten.map{|book_id| CalibreBook.new(book_id)}
  end

  def initialize(book_id)
    @id = book_id
  end

  def id
    return @id
  end

  def title
    @title ||= @@db.execute("select title from books where id = #{@id}").first.first
  end

  def author #getting first author, there might be more
    @author ||= @@db.execute("SELECT name FROM authors JOIN books_authors_link ON authors.id=books_authors_link.author WHERE books_authors_link.book=#{@id}").first.first
  end

  def series
    return @series unless @series.nil?
    query = @@db.execute("SELECT name FROM series JOIN books_series_link ON series.id=books_series_link.series WHERE books_series_link.book=#{@id}")
    if query.size > 0
       @series = query.first.first
    else
       @series = ""
    end
    return @series
  end

  def series_index
    return @series_index unless @series_index.nil?
    query = @@db.execute("select series_index from books where id = #{@id}")
    if query.size>0
      @series_index = query.first.first
    else
      @series_index = 0
    end
    return @series_index
  end

  def description
    return @description unless @description.nil?
    begin
      @description = @@db.execute("select text from comments where book = #{@id}").first.first
    rescue
      @description = ""
    end
    return @description
  end

  def book_path
    @book_path ||= @@db.execute("select path from books where id = #{@id}").first.first
  end

  def cover
    return @cover unless @cover.nil?
    cover_bool = @@db.execute("select has_cover from books where id = #{@id}").first.first
    if cover_bool
      @cover = "#{@@calibre_path}/#{book_path}/cover.jpg"
      return @cover
    else
      return nil
    end
  end

  def cover_color
    return @cover_color unless @cover_color.nil?
    img =  Magick::Image.read(self.cover).first
    img_small = img.resize(0.1)
    color = img.pixel_color(2,img.base_rows*0.025)
    colorhex = [color.red, color.green, color.blue].map{|x| x.to_s(16)[0...2].ljust(2, '0')}.join.upcase
    @cover_color =  "#" + colorhex 
    return @cover_color
  end

  def cover_contrast
    return @cover_contrast unless @cover_contrast.nil?
    color_string = self.cover_color
    red = color_string[1..2].to_i(16)
    green = color_string[3..4].to_i(16)
    blue = color_string[5..6].to_i(16)
    brightness = (red + green + blue)/3.0
    if brightness > 128
      @cover_contrast = "#111"
    else
      @cover_contrast = "#eee"
    end
    return @cover_contrast
  end

  def aspect_ratio
    img =  Magick::Image.read(self.cover).first
    height = img.base_rows
    width = img.base_columns
    return width.to_f/height
  end

  def file_path
    return @file_path unless @file_path.nil?
    book_files = @@db.execute("select name, format from data where book=#{@id}")
    book_files.each do |book_file|
      if book_file.last=="EPUB"
        @file_path = "#{@@calibre_path}/#{book_path}/#{book_file.first}.epub"
        return @file_path
      end
    end
    file_ext = book_files.first.last.downcase
    @file_path = "#{@@calibre_path}/#{book_path}/#{book_files.first.first}.#{file_ext}"
    return @file_path
  end

  def page_count
    return 300 if @@pagecount_column.nil?
    @page_count ||= @@db.execute("select value from custom_column_#{@@pagecount_column} where book=#{@id}").first.first
  end
end


##  Usage
#CalibreBook.connect("/Users/matt/Documents/books/Calibre Star Trek")
#CalibreBook.some_books.sort_by{|b| [b.series,b.series_index]}.each do |b|
#  puts b.title
#  puts b.author
#  puts "#{b.series} #{b.series_index}"
#  puts "#{b.page_count} Pages"
##  puts b.file_path
##  puts b.cover
#  puts ""
#end
      
