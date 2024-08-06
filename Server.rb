require 'sinatra'
require 'line/bot'
require 'pycall/import'
include PyCall::Import

# Thêm đường dẫn tới thư mục chứa mô-đun Python
PyCall.exec("import sys; sys.path.append('C:/Users/HP/Desktop/ChatBot')")

# Nhập mô-đun Python
pyimport :model
#Test thử xem code python có hoạt động trong ruby ko?
test1 = model.simple_test
puts test1
test2= model.predict("Công ty")
puts test2
def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = "2005978961"
    config.channel_secret = "fb1a8b8650d15f675eab62403dac84a3"
    config.channel_token = "eQWCNdDvi9yIQ/lQZLfbTRgJP2PYqIh6DhIIyRq+cTbg/dD7RFHsIDOlGhaVyUhFXrzCpy1meqEhyJ0Zlkvb9ceTxvFNNJjDNGnziuDdeUYoP0cux7dQmkQqFtM9ekGGTTbhwa+Geekn3X2ubYBzTAdB04t89/1O/w1cDnyilFU="
  }
end

set :port, 4040

get '/' do
  'OK'
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        question = event.message['text']

        # Gọi hàm dự đoán của mô hình Python
        begin
          result = model.predict("Công ty")
          puts "Kết quả: #{result}"
        rescue StandardError => e
            result = "Có lỗi xảy ra khi xử lý câu hỏi: #{e.message}"
        end

        message = {
          type: 'text',
          text: result
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
        # Xử lý file ảnh hoặc video nếu cần
      end
    end
  end

  "OK"
end
