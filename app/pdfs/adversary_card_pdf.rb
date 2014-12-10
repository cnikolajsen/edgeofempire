class AdversaryCardPdf < Prawn::Document
  include CharactersHelper
  include ApplicationHelper

  def initialize(adversary, _view)
    super(left_margin: 30, right_margin: 30, top_margin: 0, bottom_margin: 0, page_size: 'A6')
    @adversaries = adversary# ||= Adversary.find(where: true)
    @adversaries = Adversary.where(true)
    #text_box @adversaries.inspect
    @adversaries.each do |adversary|
      card(adversary)
    end
  end

  def card(adv)
    fill_color '354555'
    polygon [(bounds.left + 2), (bounds.top - 9)],
            [(bounds.left + 14), (bounds.top - 2)],
            [(bounds.right - 14), (bounds.top - 2)],
            [(bounds.right - 2), (bounds.top - 9)],
            [(bounds.right - 14), (bounds.top - 16)],
            [(bounds.left + 14), (bounds.top - 16)]
    fill
    fill_color 'ffffff'
    text_box adv.name, at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom

    # ===== Characteristics =====
    characteristics = {
      brawn: adv.brawn,
      agility: adv.agility,
      intellect: adv.intellect,
      cunning: adv.cunning,
      willpower: adv.willpower,
      presence: adv.presence,
    }
    text_box characteristics.inspect
    bounding_box([bounds.left, (bounds.top - 145)], width: bounds.width, height: 50) do
      #fill_color '354555'
      #polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
      #fill
      #fill_color 'ffffff'
      #text_box "CHARACTERISTICS", width: bounds.width, height: 14, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      #fill_color '000000'

      # Brawn.
      characteristics.each do |stat|
        text_box stat[1]
      bounding_box([bounds.left, bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.brawn}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 6)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "BRAWN", size: 4, style: :normal, at: [bounds.left, (bounds.bottom + 6)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
    end
      # Agility.
      bounding_box([(bounds.left + ((bounds.width / 6) * 1)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.agility}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "AGILITY", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
      # Intellect.
      bounding_box([(bounds.left + ((bounds.width / 6) * 2)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.intellect}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "INTELLECT", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
      # Cunning.
      bounding_box([(bounds.left + ((bounds.width / 6) * 3)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.cunning}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "CUNNING", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
      # Willpower.
      bounding_box([(bounds.left + ((bounds.width / 6) * 4)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.willpower}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "WILLPOWER", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
      # Presence.
      bounding_box([(bounds.left + ((bounds.width / 6) * 5)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 16
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 14
        fill_and_stroke
        fill_color '000000'
        text_box "#{adv.presence}", size: 30, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "PRESENCE", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
    end
    # ===== /Characteristics =====

    start_new_page
  end
end