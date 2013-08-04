require_relative "PostNotificationSender.rb"

puts Mundipagg::Simulator::PostNotification.SendPostWithRandomData('http://localhost:3000/home/index', :credit)