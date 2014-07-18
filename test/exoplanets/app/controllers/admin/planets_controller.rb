class Admin::PlanetsController < Admin::ApplicationController
  load_and_authorize_resource

  def planet_params
    params.require(:planet).permit(:name, :seed, :properties)
  end
end
