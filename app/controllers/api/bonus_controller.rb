module Api
  class BonusController < ApplicationController
    def streak
      render(::Queries::Bonus::ByNoStreak.new.call(where: params[:search]).order(params[:order]))
    end
  end
end
