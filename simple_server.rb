require 'socket'
require 'mysql2'
require 'date'

# Wait for DB to be ready
time = Time.now
client = nil
while Time.now < time + 30 && client.nil?
  begin
    client = Mysql2::Client.new(host: 'mysql_db', username: 'root', password: 'password', database: 'my_awesome_db')
  rescue StandardError
    sleep 1
  end

  next if client.nil?

  puts 'Connection to DB successful!'
  client.close
end

# Connect to DB, drop and create table
client = Mysql2::Client.new(host: 'mysql_db', username: 'root', password: 'password', database: 'my_awesome_db')
client.query('DROP TABLE IF EXISTS view')
client.query('CREATE TABLE view(view_id INT AUTO_INCREMENT,
                                date DATETIME,
                                PRIMARY KEY (view_id))')

# default return
app = Proc.new do
  ['200', {'Content-Type' => 'text/html'}, ["Hello world! The time is #{Time.now}"]]
end

server = TCPServer.new 8080

while session = server.accept
  request = session.gets
  puts request

  status, headers, body = app.call({})

  session.print "HTTP/1.1 #{status}\r\n"

  client.query("INSERT INTO view(date) VALUES ('#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}')")

  headers.each do |key, value|
    session.print "#{key}: #{value}\r\n"
  end

  session.print "\r\n"

  body.each do |part|
    session.print part
  end
  session.close
end