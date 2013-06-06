module CharactersHelper

  def character_state(character)
    @return = {}
    if character.creation?
      @return['state_short'] = "Creation"
      @return['state_message'] = "This character is in it creation phase. Special rules may apply."
      @return['state_label_class'] = "warning"
      @return['state_alert_class'] = "info"
    elsif character.active?
      @return['state_short'] = "Active"
      @return['state_message'] = ""
      @return['state_label_class'] = "success"
      @return['state_alert_class'] = "info"
    elsif character.retired?
      @return['state_short'] = "Retired"
      @return['state_message'] = "Character taken off duty and is read only."
      @return['state_label_class'] = "inverse"
      @return['state_alert_class'] = "info"
    end

     @return
  end

end
