require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(15)
  end

  def score
    @letters = params[:grid]
    start_time = Time.now
    @attempt = params[:attempt]
    end_time = Time.now
    @result = run_game(@letters, @attempt, start_time, end_time)
  end

  private

  def run_game(letters, attempt, start_time, end_time)
      url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
      user_attempt = JSON.parse(open(url).read)

      # Calcul the time it takes to answer
      time_answer = end_time - start_time

      # Get the result
      if user_attempt["found"] == false && check_grid(letters, attempt) == false
          result = ["The word doesnt exist AND the letter doesnt even match you dumb!", 0]
      elsif user_attempt["found"] == false
          result = ["The word doesnt exist!", 0]
      elsif check_grid(letters, attempt) == false
          result = ["The letter doesnt match!", 0]
      else
          result = ["Well done", (user_attempt.length / time_answer)/1000]
      end
  end

  def check_grid(letters, attempt)
      counter = 0
      attempt_array = attempt.upcase.split(//)
      attempt_array.each do |letter|
        if letters.include?(letter)
         counter += 1
        end
      end

      if counter == attempt.length
        true
      else
        false
      end
  end
end

