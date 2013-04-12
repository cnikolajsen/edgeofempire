module TalentsHelper

  def talent_parser_grit(count)
    @return = {}
    @return['strain'] = count
    
    @return
  end

  def talent_parser_toughened(count)
    @return = {}
    @return['wound'] = count
    
    @return
  end

  def talent_parser_enduring(count)
    @return = {}
    @return['soak'] = count
    
    @return
  end

  def talent_parser_armormaster(count)
    @return = {}
    @return['soak'] = count
    
    @return
  end

end