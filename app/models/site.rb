require 'open-uri'
require 'nokogiri'

class Site
  include Mongoid::Document
  field :url, type: String
  field :conteudo, type: String
  field :elemento_com_conteudo_de_interesse, type: String
  field :ja_visto, type: Boolean, default: true

  def self.verifica_atualizacao

    where(:ja_visto => true).each do |site|
      begin
        texto_somente = verificar_conteudo(site)

        if texto_somente != site.conteudo
          site.conteudo = texto_somente
          site.ja_visto = false
          site.save
          enviar_email site
        end
      rescue
      end
    end
  end

  def self.verificar_conteudo(site)

    doc = Nokogiri::Slop(open(site.url))

    doc.css('script').remove
    doc.css('style').remove
    doc.xpath("//@*[starts-with(name(),'on')]").remove

    if site.elemento_com_conteudo_de_interesse.blank?
      doc.html.body.text.gsub(/[^a-zA-Z]/, '')
    else
      doc.css(site.elemento_com_conteudo_de_interesse).first.text.gsub(/[^a-zA-Z]/, '')
    end
  end

  private
  def self.enviar_email(site)

    ActionMailer::Base.smtp_settings = {
        :address => "smtp.gmail.com",
        :domain => "gmail.com",
        :port => 587,
        :user_name => "monitoramentodesites@gmail.com",
        :password => "digdindigdin",
        :authentication => "plain",
        :enable_starttls_auto => true
    }

    ActionMailer::Base.mail(
        :from => "monitoramentodesites@gmail.com",
        :to => "renanandrade_rj@hotmail.com",
        :subject => "Atualizacao no site " << site.url,
        :body => "http://monitoramentodesites.co.vu:3001/sites/#{site.id}/marcar_como_visto")
    .deliver

  end

end
