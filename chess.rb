require "readline"
require "./lib/ChessGame"

puts "  _|_"      
puts " __|__     o       ."
puts "[     ] /\\/|\\/\\   / \\     _/|    _____"
puts " )   (  \\     /  (   )   // .\\  [ | | ]   _"
puts " |   |   )   (    ) (    || \\_)  \\   /   ( )"
puts " |   |   |   |   |   |   //__\\   |   |   | |"
puts "[_____] [_____] [_____] [_____] [_____] [___]"

puts "   ___       __          _______              "
puts "  / _ \\__ __/ /  __ __  / ___/ /  ___ ___ ___"
puts " / , _/ // / _ \\/ // / / /__/ _ \\/ -_|_-<(_-<"
puts "/_/|_|\\_._/_.__/\\_, /  \\___/_//_/\\__/___/___/"
puts "               /___/                         "

def welcome
  puts "\n**** Welcome to Ruby Chess! ****"
  puts "\n[new]  start a new game"
  puts "[load] load a saved game"
  puts "[help] command list"
  puts "[quit] quit program"
  input = Readline.readline(">: ").downcase
    until handle_input(input) do
      input = Readline.readline(">: ").downcase
    end
end

def handle_input(input)
  case input
    when "help"
      Help.help

    when "load"
      game = FileManager.load
      game ? game.play : welcome

    when /^load\s\w+$/
      file = input.split[1]
      game = FileManager.load_game(file)
      game.play if game

    when "new"
      game = ChessGame.new
      game.play

    when "quit", "exit"
        puts "Goodbye!"
        exit

    else
      puts "Invalid input. Enter [help] for commands."
      return false
  end
  welcome
end

welcome
