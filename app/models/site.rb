require 'open-uri'
require 'nokogiri'

class Site
  include Mongoid::Document
  field :url, type: String
  field :conteudo, type: String

  def self.verifica_atualizacao

    sites = all

    sites.each do |site|

      begin

        doc = Nokogiri::Slop(open(site.url))

        doc.css('script').remove
        doc.css('style').remove
        doc.xpath("//@*[starts-with(name(),'on')]").remove

        texto_somente = doc.html.body.text

        if texto_somente != site.conteudo
          site.conteudo = texto_somente
          site.save
        end

      rescue
      end
    end
  end
end