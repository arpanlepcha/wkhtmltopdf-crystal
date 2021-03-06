# ---------------------------------------------------------------------------- #
# Example:     lib_pdf
# Author:      Mat
# Description: Using LibWkHtmlToPdf directly
# ---------------------------------------------------------------------------- #
require "../src/wkhtmltopdf-crystal"

puts "[Begin]"
puts "- Version: " + String.new(LibWkHtmlToPdf.wkhtmltopdf_version)

LibWkHtmlToPdf.wkhtmltopdf_init 0
gs = LibWkHtmlToPdf.wkhtmltopdf_create_global_settings

# LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "fmt", fmt
# LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "quality", "90"
# LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "screenWidth", "2048"
# LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "in", "http://www.google.com/"
LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "out", "lib_pdf.pdf"
LibWkHtmlToPdf.wkhtmltopdf_set_global_setting gs, "dpi", "300"

os = LibWkHtmlToPdf.wkhtmltopdf_create_object_settings
LibWkHtmlToPdf.wkhtmltopdf_set_object_setting os, "page", "http://www.google.com/"

# LibWkHtmlToPdf.wkhtmltopdf_set_object_setting os, "web.loadImages", "false" # skip images

c = LibWkHtmlToPdf.wkhtmltopdf_create_converter gs

# Callbacks
LibWkHtmlToPdf.wkhtmltopdf_set_warning_callback c, ->(converter : LibWkHtmlToPdf::WkhtmltopdfConverter, param : LibC::Char*) do
  puts "> warning callback (#{param}): " + String.new(param)
end
LibWkHtmlToPdf.wkhtmltopdf_set_error_callback c, ->(converter : LibWkHtmlToPdf::WkhtmltopdfConverter, param : LibC::Char*) do
  puts "> error callback (#{param}): " + String.new(param)
end
LibWkHtmlToPdf.wkhtmltopdf_set_phase_changed_callback c, ->(converter : LibWkHtmlToPdf::WkhtmltopdfConverter) do
  phase = LibWkHtmlToPdf.wkhtmltopdf_current_phase(converter)
  desc = "> phase_changed callback ["
  desc += (phase + 1).to_s + '/' + LibWkHtmlToPdf.wkhtmltopdf_phase_count(converter).to_s
  desc += "]: " + String.new(LibWkHtmlToPdf.wkhtmltopdf_phase_description(converter, phase))
  puts desc
end
LibWkHtmlToPdf.wkhtmltopdf_set_progress_changed_callback c, ->(converter : LibWkHtmlToPdf::WkhtmltopdfConverter, param : LibC::Int) do
  puts "> progress_changed callback (#{param}): " + String.new(LibWkHtmlToPdf.wkhtmltopdf_progress_string(converter))
end
LibWkHtmlToPdf.wkhtmltopdf_set_finished_callback c, ->(converter : LibWkHtmlToPdf::WkhtmltopdfConverter, param : LibC::Int) do
  puts "> finished callback (#{param})"
end

LibWkHtmlToPdf.wkhtmltopdf_add_object c, os, nil
if LibWkHtmlToPdf.wkhtmltopdf_convert(c)
  puts "> convert: done"
else
  puts "> convert: error"
end
puts "- http_error_code: " + LibWkHtmlToPdf.wkhtmltopdf_http_error_code(c).to_s

# out setting must be not set
# len = LibWkHtmlToPdf.wkhtmltopdf_get_output( c, out data )
# puts "- output length: " + len.to_s
# slice = Slice( UInt8 ).new( data, len )
# File.open( "test.pdf", "wb" ) do |file|
#   file.write slice
# end

LibWkHtmlToPdf.wkhtmltopdf_destroy_converter c
LibWkHtmlToPdf.wkhtmltopdf_destroy_object_settings os
LibWkHtmlToPdf.wkhtmltopdf_destroy_global_settings gs
LibWkHtmlToPdf.wkhtmltopdf_deinit
puts "[End]"
