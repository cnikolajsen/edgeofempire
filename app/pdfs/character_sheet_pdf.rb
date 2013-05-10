class CharacterSheetPdf < Prawn::Document

  def initialize(charcter, view)
    super()
    text "This is a character sheet"
  end
end