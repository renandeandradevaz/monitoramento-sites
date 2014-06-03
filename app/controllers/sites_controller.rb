class SitesController < ApplicationController
  before_action :set_site, only: [:show, :marcar_como_visto]

  def verifica_atualizacao
    Site.verifica_atualizacao
  end

  def marcar_como_visto
    @site.ja_visto = true
    @site.conteudo = Site.verificar_conteudo(@site)
    @site.save
    redirect_to @site.url
  end

  def marcar_tudo_como_visto
    Site.all.each do |site|
      site.ja_visto = true
      site.save
    end
  end

  def index
    @sites = Site.all
  end

  def show
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_site
    @site = Site.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:url, :elemento_com_conteudo_de_interesse)
  end
end
