# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    create_frames(shots)
  end

  def score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.score
      total_score += bonus_points(frame, index) if index < 9 && (frame.strike? || frame.spare?)
    end
    total_score
  end

  def create_frames(shots)
    @frames = []
    frame_marks = []
    shots.each do |shot|
      frame_marks << shot
      if @frames.size < 9 && (frame_marks.size >= 2 || shot == 'X')
        @frames << Frame.new(frame_marks)
        frame_marks = []
      end
    end
    @frames << Frame.new(frame_marks)
  end

  def bonus_points(frame, index)
    frame.strike? ? strike_bonus(index) : spare_bonus(index)
  end

  def strike_bonus(index)
    next_frame = @frames[index + 1]

    if next_frame.strike? && index < 8
      next_frame.score + @frames[index + 2].shots.first.score
    else
      next_frame.shots[0].score + next_frame.shots[1].score
    end
  end

  def spare_bonus(index)
    @frames[index + 1].shots.first.score
  end
end
