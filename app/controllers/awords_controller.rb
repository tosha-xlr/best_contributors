class AwordsController < ApplicationController
  def index
    @default_repo = 'https://github.com/rails/rails/'
  end
  def awords
    @repo_name =  params[:repo] ? params[:repo][:repo_name] : 'https://github.com/rails/rails/'
    @repo_api_name = "https://api.github.com/repos" + @repo_name[18..-1] + "contributors?sort=contributions&sort=order&per_page=3"
  end
  def pdf() end
end
