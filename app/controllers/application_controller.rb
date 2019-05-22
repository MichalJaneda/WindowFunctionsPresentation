class ApplicationController < ActionController::API
  private

  def render(body)
    super(json: body)
  end
end
