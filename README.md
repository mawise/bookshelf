# 3D Bookshelf

Inspired by [https://scastiel.dev/animated-3d-book-css] and [https://github.com/janeczku/calibre-web]

[[animated gif]]

Usage:

```bash
bundle install
ruby app.rb <path-to-calibre-library>
```

Optionally: Install the [count pages](https://github.com/kiwidude68/calibre_plugins/tree/main/count_pages) Calibre plugin to make the books variable-width based on estimated page counts.  Configure the plugin with a custom column named `pagecount` and the app will automatically discover any page-count data.
