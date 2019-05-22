module Api
  class BonusController < ApplicationController
    def streak
      render(data: ::Queries::Bonus::ByNoStreak.new.call.order(params[:order]))
    end
  end
end
