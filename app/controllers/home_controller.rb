class HomeController < ApplicationController
  def index
  end

  def write
    command = params[:command]
    `echo "#{command}" > public/actual_code.rb`
    output = `ruby public/actual_code.rb`

    render json: { response: output }
  end
end