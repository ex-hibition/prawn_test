require 'bundler'
Bundler.require

pdf = Prawn::Document.new

pdf.font "vendor/fonts/ipaexg.ttf"
pdf.text "こんにちはプローン！"
pdf.render_file "hello.pdf"
