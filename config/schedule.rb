every 2.hours do
  runner "Site.verifica_atualizacao"
end

every 2.minutes do
  runner "Site.verifica_atualizacao"
end


