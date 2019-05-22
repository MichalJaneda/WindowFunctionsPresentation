module Api
  class PaymentsController < ApplicationController
    def in_month
      render(::Queries::Payment::InMonth.new.call)
    end
  end
end
