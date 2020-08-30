class NextGame < Game
  def onmt_h
    [id_h, date_h, location_h.reject{|k,v| k == 'ATTENDANCE'}, teams_h].inject(&:merge).map{|k,v| ["NEXT-#{k}", v] }.to_h
  end

  def onmt_name
    "GAME-#{id}"
  end

  def omnt_entity_name
    "G-#{id}"
  end
end