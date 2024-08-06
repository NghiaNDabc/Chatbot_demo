require 'pycall/import'
include PyCall::Import

# Thêm đường dẫn tới thư mục chứa mô-đun Python
PyCall.exec("import sys; sys.path.append('C:/Users/HP/Desktop/ChatBot')")

# Nhập mô-đun Python
pyimport :model

# Vòng lặp liên tục để nhận input từ người dùng và gọi mô-đun Python
loop do
  print "Nhập câu hỏi (hoặc gõ 'exit' để thoát): "
  user_input = gets.chomp
  break if user_input.downcase == 'exit'

  begin
    result = model.predict(user_input)
    puts "Kết quả: #{result}"
  rescue StandardError => e
    puts "Có lỗi xảy ra khi gọi mô-đun: #{e.message}"
  end
end

puts "Chương trình kết thúc."

