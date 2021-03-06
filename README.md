# WkHtmlToPdf for Crystal - PROJECT UNMAINTAINED [![Build Status](https://travis-ci.org/blocknotes/wkhtmltopdf-crystal.svg)](https://travis-ci.org/blocknotes/wkhtmltopdf-crystal)

> *This project is not maintained anymore*
>
> *If you like it or continue to use it fork it please.*

* * *
* * *

Crystal wrapper for libwkhtmltox C library.

*wkhtmltopdf* and *wkhtmltoimage* permit to render HTML into PDF and various image formats using the Qt WebKit rendering engine - see [wkhtmltopdf.org](http://wkhtmltopdf.org)

## Requirements

- *libwkhtmltox* must be installed
- *pkg-config* must be available

## Installation

- Add this to your application's `shard.yml`:

```yml
dependencies:
  wkhtmltopdf-crystal:
    github: blocknotes/wkhtmltopdf-crystal
```

- If wkhtmltox library is installed but missing for Crystal compiler: copy *wkhtmltox.pc* (from lib/wkhtmltopdf-crystal folder) in a pkg-config folder (ex. /usr/local/lib/pkgconfig) or set the environment variable PKG_CONFIG_PATH with the path to *wkhtmltox.pc* before compiling
- Optinally edit *wkhtmltox.pc* with the correct path to wkhtmltox (default headers path: /usr/local/include/wkhtmltox)

## Usage

HTML to PDF:

```ruby
require "wkhtmltopdf-crystal"
Wkhtmltopdf::WkPdf.new( "test.pdf" ).convert( "<h3>Just a test</h3>" )
```

Fetch URL content and convert it to JPG:

```ruby
require "wkhtmltopdf-crystal"
img = Wkhtmltopdf::WkImage.new
img.set_url "http://www.google.com"
img.set_output "test.jpg"
img.set "quality", "90"
img.convert
```

Write to buffer (only if no output is specified):

```ruby
require "wkhtmltopdf-crystal"
pdf = Wkhtmltopdf::WkPdf.new
pdf.convert "<h3>Just a test</h3>"
pdf.object_setting "footer.right", "[page] / [topage]" # Set page counter on footer
unless pdf.buffer.nil?
  puts "PDF buffer size: " + pdf.buffer.try( &.size ).to_s
end
```

Lib settings (available with `set` / `object_setting` methods on wrappers): [libwkhtmltox pagesettings](http://wkhtmltopdf.org/libwkhtmltox/pagesettings.html)

## More examples

See [examples](https://github.com/blocknotes/wkhtmltopdf-crystal/tree/master/examples) folder. Includes a Kemal example to print an ECR view in PDF.

## Troubleshooting

#### Invalid memory access

- If this component needs to be called multiple times it's necessary to initialize the library in the constructor and call deinitialize when all is done.
Example:

```ruby
require "wkhtmltopdf-crystal"
pdf = Wkhtmltopdf::WkPdf.new "", true
at_exit do
  pdf.deinitialize
end

pdf.set_output "test1.pdf"
pdf.convert "<h3>Just a test 1</h3>"

pdf.set_output "test2.pdf"
pdf.convert "<h3>Just a test 2</h3>"
```

## Contributors

- [Mattia Roccoberton](http://blocknot.es) - creator, maintainer
