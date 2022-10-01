# frozen_string_literal: true

# カレントフォルダを引数のフォルダに変更
Dir.chdir(ARGV[0])

# 該当フォルダに存在するファイルのみ読み込む
dir = Dir.glob('*')

# 最大カラム数の設定※カラム数は変動できるように変数化
maximum_column = 3.0
total_files = dir.size

# 個数と最大列数で割り縦の数を決める※割り切れない場合もあるから小数点ありで計算し切り上げる
column = (total_files.to_f / maximum_column).ceil(0)

# columnの数ごとに配列を作成
files = []
dir.each_slice(column) { |n| files << n }

# 配列ごとの最後に何もなかった場合'nil'を入れる
(maximum_column - total_files % maximum_column).to_i.times { files[-1] << nil } if files.size >= maximum_column && total_files % maximum_column != 0

# マルチバイトのファイル名があった場合に横幅を揃える。1byteは1byteにしそれ以外は2byteに。横幅を設定し、合間を' 'で埋める。
class String
  def mb_ljust(width, padding = ' ')
    output_width = each_char.map { |c| c.split(//u).length == 1 ? 1 : 2 }.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
end

# 配列の行列をtranspose入れ替え、長いファイル名を横幅にし左揃えに。
def show_files(dir, files)
  sorted_files = files.transpose
  longest_name = dir.max_by(&:size)
  sorted_files.each do |sorted_file|
    sorted_file.each do |s|
      print s.to_s.mb_ljust(longest_name.size, ' ')
    end
    print "\n"
  end
end

# 出力する
show_files(dir, files)
