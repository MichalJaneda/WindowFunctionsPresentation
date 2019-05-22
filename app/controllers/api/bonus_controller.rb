module Api
  class BonusController < ApplicationController
    def streak
      render(::Queries::Bonus::ByNoStreak.new.call.order(params[:order]))
    end
  end
end
