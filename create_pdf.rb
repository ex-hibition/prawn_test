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
		bounding_box([@x_pos, @y_pos], :width => 500) do
			text "■お客様情報"
			move_down 5
			data = [["会員ID","#{ary[0]}"],
					["氏名","#{ary[1]}"],
					["住所","#{ary[2]}"],
					["電話番号","#{ary[3]}"]]
			table data, :width => 500,
						:cell_style => {:background_color => "CEECF5", :border_color => "FFFFFF"},
						:column_widths => {0 => 150}
		end

		render_file "order_#{idx}.pdf"
		@y_pos -= 150
	end

	# -- 注文出力
	def renderOrder(ary:, idx:)
		bounding_box([@x_pos, @y_pos], :width => 500) do
			text "■お申し込み内容"
			move_down 5
			data = [["お申し込み商品","#{ary[4]}"],
					["キャンペーン", "#{ary[5]}"]]
			table data, :width => 500,
						:cell_style => {:background_color => "CEECF5", :border_color => "FFFFFF"},
						:column_widths => {0 => 150}
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
