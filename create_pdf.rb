require 'bundler'
Bundler.require


class CreatePDF < Prawn::Document
	def initialize
		super()
		font "vendor/fonts/ipaexg.ttf"
		@x_pos = 10
		@y_pos = 700
	end

	# -- ヘッダ出力
	def header(idx:)
		stroke_axis

		now = Time.now
		bounding_box([@x_pos, @y_pos], :width => 300) do
			text "create_date : #{now}"
		end

		render_file "order_#{idx}.pdf"
		@y_pos -= 30
	end

	# -- 住所出力
	def renderAddress(ary: , idx:)
		bounding_box([@x_pos, @y_pos], :width => 300) do
			stroke_bounds
			text "id : #{ary[0]}"
			text "name : #{ary[1]}"
			text "address : #{ary[2]}"
			text "tel : #{ary[3]}"
		end

		render_file "order_#{idx}.pdf"
		@y_pos -= 100
	end

	# -- 注文出力
	def renderOrder(ary:, idx:)
		bounding_box([@x_pos, @y_pos], :width => 300) do
			stroke_bounds
			text "order : #{ary[4]}"
			text "campaign : #{ary[5]}"
		end

		render_file "order_#{idx}.pdf"
		@y_pos -= 100
	end

end


# -- main
File.foreach(ARGV[0]).map.with_index do |line, i|
	arr = line.chomp.split(',')
	
	pdf = CreatePDF.new

	pdf.header(idx: i)	
	pdf.renderAddress(ary: arr, idx: i)
	pdf.renderOrder(ary: arr, idx: i)
end
