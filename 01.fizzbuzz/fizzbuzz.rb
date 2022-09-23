# frozen_string_literal: true

def fizzbuzz(number)
  if (number % 15).zero?
    puts 'FizzBuzz'
  elsif (number % 3).zero?
    puts 'Buzz'
  elsif (number % 5).zero?
    puts 'Fizz'
  else
    puts number
  end
end

(1..20).each do |n|
  fizzbuzz(n)
end
