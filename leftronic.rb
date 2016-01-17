require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'

class Leftronic
  ALLOWED_COLORS = [:red, :yellow, :green, :blue, :purple]
  attr_accessor :key
  def url=(url)
    @url = URI(url.to_s)
  end
  def url
    @url.to_s
  end

  def initialize(key, url='https://www.leftronic.com/customSend/')
    @key = key
    self.url = url
  end

  # Push anything to a widget
  def push(stream, object)
    post stream, object
  end

  # Push a Number to a widget
  def push_number(stream, point)
    post stream, point
  end

  # Push a geographic location (latitude and longitude) to a Map widget
  def push_geo(stream, lat, long, color=nil)
    post stream, 'latitude' => lat, 'longitude' => long, 'color' => color
  end

  # Push a title and message to a Text Feed widget
  def push_text(stream, title, message)
    post stream, 'title' => title, 'msg' => message
  end

  # Push a hash to a Leaderboard widget
  def push_leaderboard(stream, hash)
    leaderboard = hash.inject([]) do |array, (key, value)|
      array << {'name' => key, 'value' => value}
    end
    p leaderboard
    post stream, 'leaderboard' => leaderboard
  end

  # Push an array to a List widget
  def push_list(stream, *array)
    post stream, 'list' => array.flatten.map{|item| {'listItem' => item}}
  end

  # Push a string to an html widget
  def push_html(stream, html)
    post stream, 'html' => html
  end

  # Push an array to a table widget
  def push_table(stream, header_row, data_rows)
    data_rows.insert(0, header_row)
    post stream, 'table' => data_rows
  end

  # Push an image url to an image widget
  def push_image(stream, img_url)
    post stream, 'imgUrl' => img_url
  end

  # Push to a label widget
  def push_label(stream, label)
    post stream, 'label' => label
  end

  # Push to an xy graph
  def push_pair(stream, x, y)
    if (x.class == Array) and (y.class == Array)
      # Check that x and y are the same length
      if x.length != y.length
        raise 'Unequal array lengths.'
      end
      point = []
      for i in 0..x.length - 1
        point[i] = {'x' => x[i], 'y' => y[i]}
      end
    else
      # Just push a single point
      point = {'x' => x, 'y' => y}
    end
    post stream, point
  end

  # Push to a line graph
  def push_line(stream,point)
    post stream, point
  end

  # Clear a widget
  def clear(stream)
    post stream, 'clear', 'command'
  end

  protected

  def post(stream, params, type='point')
    request = build_request(stream, params, type)
    connection = build_connection
    connection.start{|http| http.request request}
    params
  end

  def build_request(stream, params, type)
    request = Net::HTTP::Post.new @url.request_uri
    request['Accept'] = 'application/json'
    request['Content-Type'] = 'application/json'
    request.body = {
      'accessKey' => @key,
      'streamName' => stream,
      type => params
    }.to_json
    request
  end

  def build_connection # NOTE: Does not open the connection
    connection = Net::HTTP.new @url.host, @url.port
    if @url.scheme == 'https'
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    connection
  end
end