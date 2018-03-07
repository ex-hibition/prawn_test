require 'csv'

require 'bundler'
Bundler.require


# -- PDF作成
class CreatePDF < Prawn::Document
	attr_accessor :order, :x_pos, :y_pos

  def initialize
    super()
    font "vendor/fonts/ipaexg.ttf"
    @x_pos = 10
    @y_pos = 700
  end

  # -- ヘッダ出力
  def header
  	# -- xy軸を描画
    stroke_axis
    now = Time.now
    bounding_box([x_pos, y_pos], :width => 300) do
      text "create_date : #{now}"
    end

    render_file "order_#{order[:num]}.pdf"
    self.y_pos -= 30
  end

  # -- 住所出力
  def renderAddress
    bounding_box([x_pos, y_pos], :width => 500) do
      text "■お客様情報"
      move_down 5
      data = [["会員ID","#{order[:id]}"],
  		        ["氏名","#{order[:name]}"],
  		        ["住所","#{order[:address]}"],
  		        ["電話番号","#{order[:tel]}"]]
      table data, :width => 500,
            :cell_style => {:background_color => "CEECF5", :border_color => "FFFFFF"},
            :column_widths => {0 => 150}
    end

    render_file "order_#{order[:num]}.pdf"
    self.y_pos -= 150
  end

  # -- 注文出力
  def renderOrder
    bounding_box([x_pos, y_pos], :width => 500) do
      text "■お申し込み内容"
      move_down 5
      data = [["お申し込み商品","#{order[:course]}"],
    		      ["キャンペーン", "#{order[:campaign]}"]]
      table data, :width => 500,
            :cell_style => {:background_color => "CEECF5", :border_color => "FFFFFF"},
            :column_widths => {0 => 150}
    end

    render_file "order_#{order[:num]}.pdf"
    self.y_pos -= 100
  end

	# -- 入力データ構造を定義
	Order = Struct.new(:num, :id, :name, :address, :tel, :course, :campaign)
	# -- csvファイルをOrderとして取り込む
  def importOrder(line:, idx:)
		self.order = Order.new(idx,line[0],line[1],line[2],line[3],line[4],line[5])
  end
end


if $0 == __FILE__
	begin
		# -- 入力ファイルCSV
		INPUT = ARGV[0]
		  
		# -- CSVファイルを1行ずつ処理
		CSV.foreach(INPUT).with_index do |line, i|
			pdf = CreatePDF.new
		
			pdf.importOrder(line: line, idx: i)
		  pdf.header
		  pdf.renderAddress
		  pdf.renderOrder
		end
	rescue => err
		p err
		exit 1
	end
end
