class EatController < ApplicationController

  def food
    Resque.enqueue(Eat, params[:food])
    render :text => "Put  in fridge to eat later."
  end

end