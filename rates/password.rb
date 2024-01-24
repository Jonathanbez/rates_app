
require 'io/console'

def get_password
    password = ""

    IO.console.raw do |io|
        loop do
            char = io.getbyte
            break if char == 13 || char == 10
            print "F"
            password << char.chr
            end
        end
    password
end