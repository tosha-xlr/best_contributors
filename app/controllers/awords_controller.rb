require 'net/http'
require 'prawn'
require 'zip'

class AwordsController < ApplicationController
  def index
    @default_repo = 'https://github.com/rails/rails/'
  end
  def awords
    respond_to do |format|
      format.html do
        @repo_name = params[:repo] ? params[:repo][:repo_name] : 'https://github.com/rails/rails/'
        uri = URI.parse(@repo_name)
        path = "/#{uri.path}/".gsub('//','/')
        @repo_api_name = "https://api.github.com/repos#{path}contributors?sort=contributions&sort=order&per_page=3"
        resp = Net::HTTP.get_response(URI.parse(@repo_api_name))
        @result = JSON.load(resp.body).map{|x|x["login"]} rescue []
      end
      format.zip do
        filename = 'awords.zip'
        temp_file = Tempfile.new(filename)

        begin
          Zip::OutputStream.open(temp_file) do |zos|
            params[:persons].each_with_index do |person, i|
              zos.put_next_entry "aword #{i+1} #{person}.pdf"
              zos << get_aword_pdf(person, i+1).render
            end
          end
          zip_data = File.read(temp_file.path)
          send_data zip_data,
            filename:Time.now.strftime("awords %d-%m-%y [%T].zip"),
            type:'application/zip',
            disposition:'attachment'
        ensure
          temp_file.close
          temp_file.unlink
        end
      end
    end
  end
  def get_aword_pdf person, number
    pdf = Prawn::Document.new
    pdf.move_down 250
    pdf.text "PDF ##{number}", size:80, align: :center
    pdf.move_down 30
    pdf.text "The awords goes to", size:35, align: :center
    pdf.move_down 70
    pdf.text person, size:35, align: :center
    pdf
  end
  def aword
    respond_to do |format|
      format.html
      format.pdf do
        pdf = get_aword_pdf params[:person], params[:number]
        send_data pdf.render,
          filename:"aword #{params[:number]} #{params[:person]}.pdf",
          type:'application/pdf',
          disposition:'inline'
      end
    end
  end
end
