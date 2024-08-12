# 3D Bookshelf

Inspired by [https://scastiel.dev/animated-3d-book-css] and [https://github.com/janeczku/calibre-web]

![](https://raw.githubusercontent.com/mawise/bookshelf/master/demo.gif)

This is a 3D bookshelf to browse ebooks. It pulls ebook metadata and cover art from a [Calibre](https://calibre-ebook.com/) library.  It uses the cover image aspect ratio to determine book height, all books are the same width.  It uses page-count data (if available) to determine the thickness of the book.  The Calibre `comment` metadata shows up as the back-cover text along with a book download link and page count.

Special thanks to [Brandon Sanderson](https://www.brandonsanderson.com/) and [Cory Doctorow](https://pluralistic.net/) who publish their books without DRM, and to [Standard Ebooks](https://standardebooks.org/) and [Planet Ebook](https://www.planetebook.com/) for beautifully typeset public domain ebooks.  

## Usage

```bash
bundle install
ruby app.rb <path-to-calibre-library>
```

Optionally: Install the [count pages](https://github.com/kiwidude68/calibre_plugins/tree/main/count_pages) Calibre plugin to make the books variable-width based on estimated page counts.  Configure the plugin with a custom column named `pagecount` and the app will automatically discover any page-count data.
