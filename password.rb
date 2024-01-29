
require 'io/console'

def get_password
    password = ""

    IO.console.raw do |io|
        loop do
            char = io.getbyte
            break if char == 13
            print "*"
            password << char.chr
            end
        end
    password.chomp
end
