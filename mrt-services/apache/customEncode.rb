#! /usr/bin/ruby

$stdout.sync = true
$gone = "http://localhost/404.html"

while (line = $stdin.gets) do
   begin

      inputURL = line.chop
      inputURL.gsub!("?", "%3F")

      # redirect
      $stdout.print "#{inputURL}\n"

   rescue Exception => e
      $stdout.print "#{$gone}\n"
   end

end   # end while

