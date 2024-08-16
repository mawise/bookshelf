# Allow books to display a logo for the series on the spine.
# Configure by creating a `logos.csv` file, each row should
# be two entries: the name of the series, then the file
# indicator for logo files.  If the file indicator is:
# "harrypotter", then place two files in `public/logos/`:
# "harrypotter-white.png" and "harrypotter-black.png".
# similarly, create two files for each indicator.  The
# images should be monochrome, with the same color as the
# filename, with transparent backgrounds.  If the spine
# color is light, we use the `-black.png` file.  If the
# spine color is dark, we use the `-white.png` file.

require 'csv'
require 'rmagick'

class BookLogo
      @@logos=[]
      begin
        CSV.read("logos.csv").each do |row|
          series = row.first
          file = row.last
          @@logos << [series, file]
        end
      rescue
      end


  def initialize(series)
    if series.nil?
      raise "Cannot create a BookLogo with a nil series"
    end
    @indicator = nil
    @@logos.each do |prefix, indicator|
      if series.start_with? prefix
        @indicator = indicator
        break
      end
    end
    ## memoize the result in a class variable for other books?
  end

  def has_logo?
    !@indicator.nil?
  end

  ## use aspect ratio to get width given target height
  def width_at_height(height)
    return height.to_f*columns/rows.to_f
  end

  def columns
    @img ||= Magick::Image.read("public#{white}").first
    @img.base_columns
  end

  def rows
    @img ||= Magick::Image.read("public#{white}").first
    @img.base_rows
  end

  # pass the desired color, should be the output of CalibreBook::cover_contrast
  def image_path(color)
    if color.start_with? "#0" or color.start_with? "#1" or color.start_with? "#2"
      return black
    else
      return white
    end
  end

  def white
    "/logos/#{@indicator}-white.png"
  end

  def black
    "/logos/#{@indicator}-black.png"
  end

end
