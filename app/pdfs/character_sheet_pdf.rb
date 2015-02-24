# Character Sheet PDF.
class CharacterSheetPdf < Prawn::Document
  include CharactersHelper
  include ApplicationHelper

  def initialize(character, _view)
    super(left_margin: 30, right_margin: 30, top_margin: 0, bottom_margin: 0, page_size: 'A4')
    @character = character

    page_1
    page_2
    page_3
    page_4
  end

  def page_1
    fill_color '000000'
    rectangle [(bounds.right - 115), bounds.top], 111, 60 # logo box
    fill
    image "#{Rails.root}/public/eote_logo_white.png",
          at: [(bounds.right - 105), (bounds.top - 5)], width: 90

    fill_color 'C0C0C0'
    rounded_rectangle [0, 690], bounds.width, 83, 10 # Vitals box
    fill

    # ===== Character details =====
    bounding_box([bounds.left, bounds.top], width: 415, height: 72) do
      fill_color 'c8c8c8'
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 3 # Character box
      fill
      fill_color '505b4d'
      draw_text 'CHARACTER NAME', size: 10, style: :bold, at: [15, (bounds.top - 20)]
      draw_text 'SPECIES', size: 8, at: [15, (bounds.top - 35)]
      draw_text 'CAREER', size: 8, at: [15, (bounds.top - 50)]
      draw_text 'SPECIALIZATION TREES', size: 8, at: [15, (bounds.top - 65)]
      fill_color '3e463b'
      draw_text "#{@character.name}", size: 12, at: [140, (bounds.top - 20)]
      draw_text "#{@character.race.name}", size: 8, at: [140, (bounds.top - 35)]
      draw_text "#{@character.career.name}", size: 8, at: [140, (bounds.top - 50)]
      draw_text @character.specializations.join(' / '), size: 8, at: [140, (bounds.top - 65)]
    end
    # ===== /Character details =====

    # ===== Vitals =====
    bounding_box([bounds.left, (bounds.top - 79)], width: bounds.width, height: 55) do
      bounding_box([bounds.left, bounds.top], width: (bounds.width / 5), height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left, (bounds.top - 43)],
                  [bounds.left, (bounds.top - 8)],
                  [(bounds.left + 14), bounds.top],
                  [(bounds.right - 14), bounds.top],
                  [bounds.right, (bounds.top - 8)],
                  [bounds.right, (bounds.top - 43)],
                  [(bounds.right - 14), (bounds.top - 53)],
                  [(bounds.left + 14), (bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2), (bounds.top - 9)],
                [(bounds.left + 14), (bounds.top - 2)],
                [(bounds.right - 14), (bounds.top - 2)],
                [(bounds.right - 2), (bounds.top - 9)],
                [(bounds.right - 14), (bounds.top - 16)],
                [(bounds.left + 14), (bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box 'WOUNDS', at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.wound_threshold}", at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        if @character.wounds > 0
          text_box "#{@character.wounds}", at: [(bounds.left + 50), (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        end
        line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
        fill
        text_box 'THRESHOLD', at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
        text_box 'CURRENT', at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      end
      bounding_box([(bounds.left + ((bounds.width / 5) * 1)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left,(bounds.top - 43)], [bounds.left,(bounds.top - 8)], [(bounds.left + 14),bounds.top], [(bounds.right - 14),bounds.top], [bounds.right,(bounds.top - 8)], [bounds.right,(bounds.top - 43)], [(bounds.right - 14),(bounds.top - 53)], [(bounds.left + 14),(bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2),(bounds.top - 9)], [(bounds.left + 14),(bounds.top - 2)], [(bounds.right - 14),(bounds.top - 2)], [(bounds.right - 2),(bounds.top - 9)], [(bounds.right - 14),(bounds.top - 16)], [(bounds.left + 14),(bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box 'STRAIN', at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.strain_threshold}", at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        if @character.strain > 0
          text_box "#{@character.strain}", at: [(bounds.left + 50), (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        end
        line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
        fill
        text_box 'THRESHOLD', at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
        text_box 'CURRENT', at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      end
      bounding_box([(bounds.left + ((bounds.width / 5) * 2)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left,(bounds.top - 43)], [bounds.left,(bounds.top - 8)], [(bounds.left + 14),bounds.top], [(bounds.right - 14),bounds.top], [bounds.right,(bounds.top - 8)], [bounds.right,(bounds.top - 43)], [(bounds.right - 14),(bounds.top - 53)], [(bounds.left + 14),(bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2),(bounds.top - 9)], [(bounds.left + 14),(bounds.top - 2)], [(bounds.right - 14),(bounds.top - 2)], [(bounds.right - 2),(bounds.top - 9)], [(bounds.right - 14),(bounds.top - 16)], [(bounds.left + 14),(bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box 'SOAK VALUE', at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.soak}", at: [bounds.left, (bounds.top - 18)], width: bounds.width, height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
      end
      bounding_box([(bounds.left + ((bounds.width / 5) * 3)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left,(bounds.top - 43)], [bounds.left,(bounds.top - 8)], [(bounds.left + 14),bounds.top], [(bounds.right - 14),bounds.top], [bounds.right,(bounds.top - 8)], [bounds.right,(bounds.top - 43)], [(bounds.right - 14),(bounds.top - 53)], [(bounds.left + 14),(bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2),(bounds.top - 9)], [(bounds.left + 14),(bounds.top - 2)], [(bounds.right - 14),(bounds.top - 2)], [(bounds.right - 2),(bounds.top - 9)], [(bounds.right - 14),(bounds.top - 16)], [(bounds.left + 14),(bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box "DEFENSE", at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.defense}", at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
        fill
        text_box "RANGED", at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
        text_box "MELEE", at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      end
      bounding_box([(bounds.left + ((bounds.width / 5) * 4)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left,(bounds.top - 43)], [bounds.left,(bounds.top - 8)], [(bounds.left + 14),bounds.top], [(bounds.right - 14),bounds.top], [bounds.right,(bounds.top - 8)], [bounds.right,(bounds.top - 43)], [(bounds.right - 14),(bounds.top - 53)], [(bounds.left + 14),(bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2),(bounds.top - 9)], [(bounds.left + 14),(bounds.top - 2)], [(bounds.right - 14),(bounds.top - 2)], [(bounds.right - 2),(bounds.top - 9)], [(bounds.right - 14),(bounds.top - 16)], [(bounds.left + 14),(bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box "ENCUMBRANCE", at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.encumbrance_threshold.to_s}", at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        text_box "#{@character.encumbrance_value.to_s}", at: [(bounds.left + 50), (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
        fill
        text_box "THRESHOLD", at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
        text_box "CURRENT", at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      end
    end
    # ===== /Vitals =====

    # ===== Characteristics =====
    bounding_box([bounds.left, (bounds.top - 145)], width: bounds.width, height: 85) do
      fill_color '354555'
      polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
      fill
      fill_color 'ffffff'
      text_box "CHARACTERISTICS", width: bounds.width, height: 14, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      fill_color '000000'

      # Brawn.
      bounding_box([bounds.left, bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.brawn}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "BRAWN", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
      # Agility.
      bounding_box([(bounds.left + ((bounds.width / 6) * 1)), bounds.top], width: (bounds.width / 6), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.agility}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
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
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.intellect}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
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
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.cunning}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
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
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.willpower}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
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
        circle [(bounds.width / 2),(bounds.height / 2)], 26
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.height / 2)], 24
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.presence}", size: 40, style: :bold, at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color '751010'
        rounded_rectangle [(bounds.left + 10), (bounds.bottom + 13)], (bounds.width - 20), 13, 5
        fill
        fill_color 'ffffff'
        text_box "PRESENCE", size: 9, style: :normal, at: [bounds.left, (bounds.bottom + 13)], width: bounds.width, height: 13,  align: :center, valign: :center
        fill
      end
    end
    # ===== /Characteristics =====

    # ===== Status Effects and Force =====
    bounding_box([(bounds.right - ((bounds.width - 20) / 2) - 15), (bounds.top - 237)], width: (((bounds.width - 20) / 2) + 15), height: 83) do
      stroke_color "000000"
      bounding_box([bounds.left, bounds.top], width: 65, height: bounds.height) do
        fill_color '354555'
        skill_label_top_bound = bounds.top
        polygon [bounds.left, (skill_label_top_bound - 7)], [(bounds.left + 5), (skill_label_top_bound - 2)], [(bounds.right - 5), (skill_label_top_bound - 2)], [(bounds.right), (skill_label_top_bound - 7)], [(bounds.right - 5), (skill_label_top_bound - 12)], [(bounds.left + 5), (skill_label_top_bound - 12)]
        fill
        fill_color 'ffffff'
        text_box "STAUS EFFECTS", width: bounds.width, height: 14, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center, at: [bounds.left, skill_label_top_bound]

        fill_color '751010'
        rectangle [bounds.left, (bounds.top - 20)], bounds.width, 10
        fill
        fill_color 'ffffff'
        rectangle [(bounds.right - 13), (bounds.top - 20)], 10, 10
        fill_and_stroke
        text_box "STAGGERED", width: bounds.width, height: 10, overflow: :shrink_to_fit, size: 5, style: :bold, align: :left, valign: :center, at: [(bounds.left + 3), (bounds.top - 20)]
        if @character.staggered
          fill_color '000000'
          text_box "X", width: 10, height: 10, size: 7, style: :bold, align: :left, valign: :center, at: [(bounds.right - 10), (bounds.top - 20)]
        end

        fill_color '751010'
        rectangle [bounds.left, (bounds.top - 36)], bounds.width, 10
        fill
        fill_color 'ffffff'
        rectangle [(bounds.right - 13), (bounds.top - 36)], 10, 10
        fill_and_stroke
        text_box "IMMOBILIZED", width: bounds.width, height: 10, overflow: :shrink_to_fit, size: 5, style: :bold, align: :left, valign: :center, at: [(bounds.left + 3), (bounds.top - 36)]
        if @character.immobilized
          fill_color '000000'
          text_box "X", width: 10, height: 10, size: 7, style: :bold, align: :left, valign: :center, at: [(bounds.right - 10), (bounds.top - 36)]
        end

        fill_color '751010'
        rectangle [bounds.left, (bounds.top - 52)], bounds.width, 10
        fill
        fill_color 'ffffff'
        rectangle [(bounds.right - 13), (bounds.top - 52)], 10, 10
        fill_and_stroke
        text_box "DISORIENTED", width: bounds.width, height: 10, overflow: :shrink_to_fit, size: 5, style: :bold, align: :left, valign: :center, at: [(bounds.left + 3), (bounds.top - 52)]
        if @character.disoriented
          fill_color '000000'
          text_box "X", width: 10, height: 10, size: 7, style: :bold, align: :left, valign: :center, at: [(bounds.right - 10), (bounds.top - 52)]
        end

        fill_color '751010'
        rectangle [bounds.left, (bounds.top - 68)], bounds.width, 10
        fill
        fill_color 'ffffff'
        rectangle [(bounds.right - 13), (bounds.top - 68)], 10, 10
        fill_and_stroke
      end

      bounding_box([(bounds.left + 70), bounds.top], width: (bounds.width - 70), height: bounds.height) do
        fill_color 'C0C0C0'
        rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
        fill

        bounding_box([(bounds.left + 5), (bounds.top - 5)], width: 80, height: bounds.height) do
          # Outer Box.
          stroke do
            self.line_width = 2
            fill_color 'ffffff'
            stroke_color '474D46'
            polygon [bounds.left,(bounds.top - 43)], [bounds.left,(bounds.top - 8)], [(bounds.left + 14),bounds.top], [(bounds.right - 14),bounds.top], [bounds.right,(bounds.top - 8)], [bounds.right,(bounds.top - 43)], [(bounds.right - 14),(bounds.top - 53)], [(bounds.left + 14),(bounds.top - 53)]
            fill_and_stroke
          end
          # Label box.
          fill_color '354555'
          polygon [(bounds.left + 2),(bounds.top - 9)], [(bounds.left + 14),(bounds.top - 2)], [(bounds.right - 14),(bounds.top - 2)], [(bounds.right - 2),(bounds.top - 9)], [(bounds.right - 14),(bounds.top - 16)], [(bounds.left + 14),(bounds.top - 16)]
          fill
          fill_color 'ffffff'
          text_box "FORCE POOL", at: [bounds.left, bounds.top], width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :bottom
          fill_color '000000'
          text_box "", at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
          line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
          fill
          text_box "COMMITTED", at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center
          text_box "AVAILABLE", at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center
        end

        fill_color '000000'
        rectangle [(bounds.left + 118), (bounds.top - 8)], 57, 57
        fill
        circle [(bounds.left + 146),((bounds.height / 2) + 5)], 32
        fill
        text_box "FORCE RANK", at: [(bounds.left + 95), (bounds.top - 70)], width: 104, height: 10, overflow: :shrink_to_fit, size: 8, style: :bold, align: :center, valign: :center
        fill_color 'ffffff'
        #self.line_width = 2
        rectangle [(bounds.left + 120), (bounds.top - 10)], 52, 52
        fill
        circle [(bounds.left + 146),((bounds.height / 2) + 5)], 30
        fill
        fill_color '000000'
        text_box "#{@character.force_rating}", at: [(bounds.left + 121), (bounds.top - 15)], width: 52, height: 52, overflow: :shrink_to_fit, size: 40, style: :bold, align: :center, valign: :center
      end
    end
    # ===== /Status Effects and Force =====

    # ===== Skills =====
    bounding_box([bounds.left, (bounds.top - 230)], width: ((bounds.width - 20) / 2), height: 398) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5 # Left skills box
      fill
      fill_color '000000'

      @combat_skills = ['Brawl', 'Gunnery', 'Melee', 'Ranged (Light)',
                        'Ranged (Heavy)', 'Lightsaber']

      combat = Array.new
      knowledge = Array.new
      other = Array.new
      @character.character_skills.each do |skill|
        if @combat_skills.include?(skill.skill.name)
          combat << skill
        elsif /^Knowledge.*?$/.match(skill.skill.name)
          knowledge << skill
        else
          other << skill
        end
      end
      dice_ability = "#{Rails.root}/public/dice/blank.png"

      combat_skills = combat.map do |skill|
        font 'Helvetica', size: 8
        total_ranks = skill_total_ranks(skill)
        dice_ability = "#{Rails.root}/public/dice/blank.png"
        dice_proficiency = "#{Rails.root}/public/dice/blank.png"
        if @character.send(skill.skill.characteristic.downcase) == total_ranks
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
        elsif @character.send(skill.skill.characteristic.downcase) < total_ranks
          dice_ability = "#{Rails.root}/public/dice/ability_#{total_ranks - @character.send(skill.skill.characteristic.downcase)}.png"
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
        else
          dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - total_ranks}.png"
          if total_ranks > 0
            dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
          end
        end
        [
          "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, omission: '')})",
          if is_career_skill(skill.skill.id, false, @character)
            'Yes'
          end,
          { image: dice_ability, fit: [58, 12], position: :right, vposition: :center },
          { image: dice_proficiency, fit: [58, 12], position: :left, vposition: :center }
        ]
      end

      general_skills = other.map do |skill|
        font 'Helvetica', size: 8
        total_ranks = skill_total_ranks(skill)
        dice_ability = "#{Rails.root}/public/dice/blank.png"
        dice_proficiency = "#{Rails.root}/public/dice/blank.png"
        if @character.send(skill.skill.characteristic.downcase) == total_ranks
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
        elsif @character.send(skill.skill.characteristic.downcase) < total_ranks
          dice_ability = "#{Rails.root}/public/dice/ability_#{total_ranks - @character.send(skill.skill.characteristic.downcase)}.png"
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
        else
          dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - total_ranks}.png"
          if total_ranks > 0
            dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
          end
        end
        [
          "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, :omission => '')})",
          if is_career_skill(skill.skill.id, false, @character)
            'Yes'
          end,
          {image: dice_ability, fit: [58, 12], position: :right, vposition: :center},
          {image: dice_proficiency, fit: [58, 12], position: :left, vposition: :center}
        ]
      end

      bounding_box([(bounds.left + 10), (bounds.top - 12)], width: (bounds.width / 2 - 20), height: bounds.height) do
        table [
          ['Combat skills', 'Career?', 'Dice pool']
        ],
        cell_style: {
          height: 10,
          padding: 1,
          size: 5,
          align: :center,
          border_width: 0,
          #:background_color => "FFFFFF"
        },
        width: 242,
        column_widths: [100, 22, 120]

        table combat_skills,
          cell_style: {
            height: 13,
            padding: 1,
            border_width: 0,
            #:background_color => "FFFFFF",
          },
          width: 242,
          column_widths: [100, 22, 60, 60],
          row_colors: %w[FFFFFF, C0C0C0]
      end

      bounding_box([(bounds.left + 10), (bounds.top - 103)], width: (bounds.width / 2 - 20), height: bounds.height) do
        table [
         ['General skills', 'Career?', 'Dice pool']
        ],
        cell_style: {
          height: 10,
          padding: 1,
          size: 5,
          align: :center,
          border_width: 0,
          #:background_color => "FFFFFF"
        },
        width: 242,
        column_widths: [100, 22, 120]

        table general_skills,
          cell_style: {
            height: 13,
            padding: 1,
            border_width: 0,
            #:background_color => "FFFFFF"
          },
          width: 242,
          column_widths: [100, 22, 60, 60],
          row_colors: %w[FFFFFF, C0C0C0]
      end


      #bounding_box([320, 280], width: 242, height: 335) do
      #  table [
      #   ['Custom skills', 'Career?', 'Dice pool']
      #  ],
      #  cell_style: {
      #    height: 10,
      #    padding: 1,
      #    size: 5,
      #    align: :center
      #  },
      #  width: 242,
      #  column_widths: [100, 22, 120]
      #
       # table custom_skills,
       #   cell_style: {
       #     :background_color => "FFFFFF",
       #     height: 15,
       #     padding: 1,
       #     },
       #     width: 242,
       #     column_widths: [100, 22, 60, 60]
      #end

      #bounding_box([((bounds.width / 2) + 20), (bounds.top - 225)], width: (bounds.width / 2 - 30), height: 100) do
      #  stroke_bounds
      #end
    end

    bounding_box([(bounds.right - ((bounds.width - 20) / 2)), (bounds.top - 320)], width: ((bounds.width - 20) / 2), height: 308) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
      fill
      fill_color '000000'

      knowledge = Array.new
      @character.character_skills.each do |skill|
        if /^Knowledge.*?$/.match(skill.skill.name)
          knowledge << skill
        end
      end
      dice_ability = "#{Rails.root}/public/dice/blank.png"

      knowledge_skills = knowledge.map do |skill|
        font 'Helvetica', size: 8
        total_ranks = skill_total_ranks(skill)
        dice_ability = "#{Rails.root}/public/dice/blank.png"
        dice_proficiency = "#{Rails.root}/public/dice/blank.png"
        if @character.send(skill.skill.characteristic.downcase) == total_ranks
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
        elsif @character.send(skill.skill.characteristic.downcase) < total_ranks
          dice_ability = "#{Rails.root}/public/dice/ability_#{total_ranks - @character.send(skill.skill.characteristic.downcase)}.png"
          dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{@character.send(skill.skill.characteristic.downcase)}.png"
        else
          dice_ability = "#{Rails.root}/public/dice/ability_#{@character.send(skill.skill.characteristic.downcase) - total_ranks}.png"
          if total_ranks > 0
            dice_proficiency = "#{Rails.root}/public/dice/proficiency_#{total_ranks}.png"
          end
        end
        [
          "#{skill.skill.name} (#{skill.skill.characteristic.truncate(3, :omission => '')})",
          if is_career_skill(skill.skill.id, false, @character)
            'Yes'
          end,
          {image: dice_ability, fit: [58, 12], position: :right, vposition: :center},
          {image: dice_proficiency, fit: [58, 12], position: :left, vposition: :center}
        ]
      end

      bounding_box([(bounds.left + 10), (bounds.top - 13)], width: (bounds.width / 2 - 20), height: bounds.height) do
        table [
         ['Knowledge skills', 'Career?', 'Dice pool']
        ],
        cell_style: {
          height: 10,
          padding: 1,
          size: 5,
          align: :center,
          border_width: 0,
          #:background_color => "FFFFFF"
        },
        width: 242,
        column_widths: [100, 22, 120]

        table knowledge_skills,
          cell_style: {
            height: 13,
            padding: 1,
            border_width: 0,
            #:background_color => "FFFFFF"
          },
          width: 242,
          column_widths: [100, 22, 60, 60],
          row_colors: %w[FFFFFF, C0C0C0]
      end

    end
    fill_color '354555'
    skill_label_top_bound = bounds.top - 320
    #polygon [(bounds.left + 200),(skill_label_top_bound - 7)], [(bounds.left + 210), (skill_label_top_bound - 2)], [(bounds.right - 210), (skill_label_top_bound - 2)], [(bounds.right - 200), (skill_label_top_bound - 7)], [(bounds.right - 210), (skill_label_top_bound - 12)], [(bounds.left + 210), (skill_label_top_bound - 12)]
    fill
    fill_color 'ffffff'
    #text_box "SKILLS", width: bounds.width, height: 14, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center, at: [bounds.left, skill_label_top_bound]
    # ===== /Skills =====

    # ===== WEAPONS =====
    bounding_box([bounds.left, (bounds.top - 635)], width: bounds.width, height: 150) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
      fill

      fill_color '354555'
      polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
      fill
      fill_color 'ffffff'
      text_box "WEAPONS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      fill_color '000000'

      if @character.attacks.any?
        weapons = @character.attacks.map do |atk|
          if atk
            font 'Helvetica', size: 8
            if atk[:skill]
              character_skill_ranks = CharacterSkill.where("character_id = ? AND skill_id = ?", @character.id, atk[:skill].id)
              ranks = character_skill_ranks.first.ranks
            else
              ranks = 0
            end

              @wq = Array.new
              atk[:qualities].each do |q|
                ranks = ''
                if q[:ranks] > 0
                  ranks = " #{q[:ranks]}"
                end
                @wq << "#{q[:name]}#{ranks}"
              end
            weapon_data = @wq.join(',')

            [
              atk[:name],
              "#{atk[:skill].name}",
              atk[:damage],
              atk[:range],
              atk[:crit],
              weapon_data
            ]
          end
        end

        (10 - weapons.count).times do
          weapons << ['','','','','','']
        end

        bounding_box([(bounds.left + 10), (bounds.top - 20)], width: (bounds.width - 20), height: bounds.height) do
          table [
           ['WEAPON', 'SKILL', 'DAMAGE', 'RANGE', 'CRIT', 'SPECIAL']
          ],
          cell_style: {
            height: 10,
            padding: 1,
            size: 5,
            align: :left,
            border_width: 0,
            #:background_color => "FFFFFF",
          },
          width: bounds.width,
          column_widths: {0 => 115, 1 => 100, 2 => 42, 3 => 42, 4 => 42}

          table weapons,
            cell_style: {
              #:background_color => "FFFFFF",
              height: 12,
              padding: [2, 3],
              size: 6,
              border_width: 0,
            },
            width: bounds.width,
            column_widths: {0 => 115, 1 => 100, 2 => 42, 3 => 42, 4 => 42},
            row_colors: %w[FFFFFF, C0C0C0]
        end
      end
    end
    # ===== /WEAPONS =====

    # ===== FOOTER =====
    bounding_box([bounds.left, (bounds.bottom + 45)], width: bounds.width, height: 45) do
      bounding_box([bounds.left, bounds.top], width: 90, height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left, (bounds.bottom + 13)], [bounds.left, (bounds.top - 13)], [(bounds.left + 15),bounds.top], [(bounds.right - 15),bounds.top], [bounds.right,(bounds.top - 13)], [bounds.right,(bounds.bottom + 13)], [(bounds.right - 15), (bounds.bottom + 2)], [(bounds.left + 15), (bounds.bottom + 2)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        #polygon [(bounds.left + 11),(bounds.top - 7)], [(bounds.left + 17),(bounds.top - 2)], [(bounds.right - 17),(bounds.top - 2)], [(bounds.right - 11),(bounds.top - 7)], [(bounds.right - 17),(bounds.top - 11)], [(bounds.left + 17),(bounds.top - 11)]
        polygon [(bounds.left + 11),(bounds.bottom + 9)], [(bounds.left + 17),(bounds.bottom + 4)], [(bounds.right - 17),(bounds.bottom + 4)], [(bounds.right - 11),(bounds.bottom + 9)], [(bounds.right - 17),(bounds.bottom + 13)], [(bounds.left + 17),(bounds.bottom + 13)]
        fill
        fill_color 'ffffff'
        text_box "TOTAL XP", at: [bounds.left, (bounds.bottom + 12)], width: bounds.width, height: 8, overflow: :shrink_to_fit, size: 6, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{character_available_experience}", at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
      end

      bounding_box([(bounds.left + 100), (bounds.bottom + 45)], width: (bounds.width - 200), height: 45) do
        fill_color '751010'
        rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
        fill

        fill_color 'ffffff'
        text_box "CHARACTER SHEET", at: [bounds.left, bounds.top], width: bounds.width, height: bounds.height, size: 15, style: :bold, align: :center, valign: :center
      end

      bounding_box([(bounds.right - 90), bounds.top], width: 90, height: bounds.height) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left, (bounds.bottom + 13)], [bounds.left, (bounds.top - 13)], [(bounds.left + 15),bounds.top], [(bounds.right - 15),bounds.top], [bounds.right,(bounds.top - 13)], [bounds.right,(bounds.bottom + 13)], [(bounds.right - 15), (bounds.bottom + 2)], [(bounds.left + 15), (bounds.bottom + 2)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 11),(bounds.bottom + 9)], [(bounds.left + 17),(bounds.bottom + 4)], [(bounds.right - 17),(bounds.bottom + 4)], [(bounds.right - 11),(bounds.bottom + 9)], [(bounds.right - 17),(bounds.bottom + 13)], [(bounds.left + 17),(bounds.bottom + 13)]
        fill
        fill_color 'ffffff'
        text_box "AVAILABLE XP", at: [bounds.left, (bounds.bottom + 12)], width: bounds.width, height: 8, overflow: :shrink_to_fit, size: 6, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{character_available_experience - character_experience_cost}", at: [bounds.left, (bounds.top - 3)], width: bounds.width, height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
      end
    end
    # ===== /FOOTER =====

    start_new_page
  end

  def page_2

  # ===== TALENTS =====
  bounding_box([bounds.left, (bounds.top - 5)], width: bounds.width, height: 240) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "TALENTS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    fill_color '000000'
    if @character.talents
      talents = @character.talents.map do |talent_id, index|
        talent = Talent.find_by_id(talent_id)
        font 'Helvetica', size: 8
        [
          talent.name,
          talent.activation,
          talent.description
        ]
      end

      (17 - talents.count).times do
        talents << ['','','']
      end

      bounding_box([(bounds.left + 10), (bounds.top - 20)], width: (bounds.width - 20), height: bounds.height) do
        table [
         ['NAME', 'ACTIVATION', 'ABILITY SUMMARY']
        ],
        cell_style: {
          height: 10,
          padding: 1,
          size: 5,
          align: :left,
          border_width: 0,
        },
        width: bounds.width,
        column_widths: {0 => 100, 1 => 100}

        unless talents.blank?
          table talents,
            cell_style: {
              #:background_color => "FFFFFF",
              height: 12,
              padding: [2, 3],
              size: 6,
              border_width: 0,
            },
            width: bounds.width,
            column_widths: {0 => 100, 1 => 100},
            row_colors: %w[FFFFFF, C0C0C0]
        end
      end
    end
  end
  # ===== /TALENTS =====

  # ===== CHARACTER DESCRIPTION =====
  bounding_box([bounds.left, (bounds.top - 260)], width: bounds.width, height: 63) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "CHARACTER DESCRIPTION", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    bounding_box([(bounds.left + 10), (bounds.top - 12)], width: (bounds.width - 20), height: bounds.height) do
      table [
       ['GENDER', 'AGE', 'HEIGHT', 'BUILD', 'HAIR', 'EYES']
      ],
      cell_style: {
        height: 10,
        padding: 1,
        size: 5,
        align: :center,
        border_width: 0,
      },
      width: bounds.width

      table [
       ["#{@character.gender}", "#{@character.age}", "#{@character.height}", "#{@character.build}", "#{@character.hair}", "#{@character.eyes}"]
      ],
      cell_style: {
        :background_color => "FFFFFF",
        height: 12,
        padding: [2, 3],
        size: 6,
        align: :center,
        border_width: 1,
      },
      width: bounds.width

      fill_color "505b4d"
      text_box "NOTABLE FEATURES", width: 40, overflow: :shrink_to_fit, size: 7, at: [bounds.left, (bounds.top - 33)]
      bounding_box([(bounds.left + 45), (bounds.top - 25)], width: (bounds.width - 45), height: 30) do
        fill_color 'FFFFFF'
        rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
        fill
        fill_color '000000'
        text_box "#{@character.notable_features}", width: (bounds.width - 10), height: bounds.height, overflow: :shrink_to_fit, size: 7, style: :normal, align: :left, valign: :top, at: [(bounds.left + 5), (bounds.top - 2)]
      end
    end
  end
  #===== /CHARACTER DESCRIPTION =====

  #===== CHARACTER MOTIVATION =====
  bounding_box([bounds.left, (bounds.top - 335)], width: bounds.width, height: 100) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "CHARACTER MOTIVATIONS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    motivations = @character.character_motivations.map do |motivation|
      [
        motivation.motivation.name,
        motivation.description
      ]
    end

    bounding_box([(bounds.left + 10), (bounds.top - 10)], width: (bounds.width - 20), height: bounds.height) do
      table [
        ['TYPE', '']
      ],
      cell_style: {
        height: 10,
        padding: 1,
        size: 5,
        align: :left,
        border_width: 0,
      },
      width: bounds.width,
      column_widths: {0 => 100}

      unless motivations.blank?
        table motivations,
        cell_style: {
          padding: [2, 3],
          size: 6,
          border_width: 0,
        },
        width: bounds.width,
        column_widths: {0 => 100},
        row_colors: %w[FFFFFF, C0C0C0]
      end
    end
  end
  #===== /CHARACTER MOTIVATION =====

  #===== CHARACTER OBLIGATION =====
  bounding_box([bounds.left, (bounds.top - 450)], width: bounds.width, height: 100) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "CHARACTER OBLIGATIONS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    obligations = @character.character_obligations.map do |obligation|
      [
        obligation.obligation.name,
        obligation.magnitude,
        obligation.description
      ]
    end

    bounding_box([(bounds.left + 10), (bounds.top - 10)], width: (bounds.width - 20), height: bounds.height) do
      table [
        ['TYPE', 'MAGNITUDE', '']
      ],
      cell_style: {
        height: 10,
        padding: 1,
        size: 5,
        align: :left,
        border_width: 0,
      },
      width: bounds.width,
      column_widths: {0 => 100, 0 => 50}

      unless obligations.blank?
        table obligations,
        cell_style: {
          padding: [2, 3],
          size: 6,
          border_width: 0,
        },
        width: bounds.width,
        column_widths: {0 => 100, 0 => 50},
        row_colors: %w[FFFFFF, C0C0C0]
      end
    end
  end
  #===== /CHARACTER OBLIGATION =====

  #===== OTHER CHARACTER NOTES =====
  bounding_box([bounds.left, (bounds.bottom + 280)], width: bounds.width, height: 220) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "OTHER CHARACTER NOTES", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    bounding_box([(bounds.left + 5), (bounds.top - 15)], width: (bounds.width - 10), height: (bounds.height - 15)) do
      fill_color 'FFFFFF'
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
      fill
      fill_color '000000'
      text_box "#{@character.bio}\n\n#{@character.other}", width: (bounds.width - 10), height: (bounds.height - 10), overflow: :shrink_to_fit, size: 7, style: :normal, align: :left, valign: :top, at: [(bounds.left + 5), (bounds.top - 5)]
    end

  end
  #===== /OTHERCHARACTER NOTES =====

  #===== FOOTER =====
  bounding_box([bounds.left, (bounds.bottom + 45)], width: bounds.width, height: 45) do
    #fill_color 'C0C0C0'
    #rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
    #fill

    bounding_box([(bounds.left + 100), (bounds.bottom + 45)], width: (bounds.width - 200), height: 45) do
      fill_color '751010'
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
      fill

      fill_color 'ffffff'
      text_box "CHARACTER DESCRIPTION SHEET", at: [bounds.left, bounds.top], width: bounds.width, height: bounds.height, size: 15, style: :bold, align: :center, valign: :center
    end

  end
  #===== /FOOTER =====

  start_new_page
end

def page_3

  #===== ARMOR =====
  fill_color "244060"
  polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
  fill
  fill_color 'ffffff'
  text_box "ARMOR", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center

  bounding_box([bounds.left, (bounds.top - 13)], width: bounds.width, height: 135) do
    bounding_box([bounds.left, bounds.top], width: (bounds.width / 2), height: 60) do
      fill_color "284765"
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
      fill

      # SOAK
      bounding_box([bounds.left, bounds.top], width: (bounds.width / 5), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.top - 25)], 22
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.top - 25)], 20
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.equipped_armor.armor.soak unless @character.equipped_armor.nil?}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color "04AEED"
        rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
        fill
        fill_color 'ffffff'
        text_box "SOAK", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
        fill
      end
      # MELEE DEFENSE
      bounding_box([(bounds.left + ((bounds.width / 5) * 1)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.top - 25)], 22
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.top - 25)], 20
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.equipped_armor.armor.defense unless @character.equipped_armor.nil?}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color "04AEED"
        rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
        fill
        fill_color 'ffffff'
        text_box "MELEE DEF", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
        fill
      end
      # RANGED DEFENSE
      bounding_box([(bounds.left + ((bounds.width / 5) * 2)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.top - 25)], 22
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.top - 25)], 20
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.equipped_armor.armor.defense unless @character.equipped_armor.nil?}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color "04AEED"
        rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
        fill
        fill_color 'ffffff'
        text_box "RANGED DEF", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
        fill
      end
      # ENCUMBRANCE
      bounding_box([(bounds.left + ((bounds.width / 5) * 3)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.top - 25)], 22
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.top - 25)], 20
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.equipped_armor.armor.encumbrance unless @character.equipped_armor.nil?}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color "04AEED"
        rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
        fill
        fill_color 'ffffff'
        text_box "ENC", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
        fill
      end
      # HARD POINTS
      bounding_box([(bounds.left + ((bounds.width / 5) * 4)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
        fill_color 'ffffff'
        self.line_width = 2
        # Outer
        circle [(bounds.width / 2),(bounds.top - 25)], 22
        fill_and_stroke
        self.line_width = 1
        # Inner
        circle [(bounds.width / 2),(bounds.top - 25)], 20
        fill_and_stroke
        fill_color '000000'
        text_box "#{@character.equipped_armor.armor.hard_points unless @character.equipped_armor.nil?}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
        fill_color "04AEED"
        rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
        fill
        fill_color 'ffffff'
        text_box "HP", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
        fill
      end
    end

    bounding_box([(bounds.left + (bounds.width / 2)), bounds.top], width: (bounds.width / 2), height: 60) do
      bounding_box([bounds.left, bounds.top], width: ((bounds.width / 4) * 3), height: bounds.height) do
        fill_color 'C0C0C0'
        rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
        fill
        fill_color 'FFFFFF'
        rounded_rectangle [(bounds.left + 2), (bounds.top - 2)], (bounds.width - 4), (bounds.height - 4), 4
        fill

        stroke do
          stroke_color "000000"
          self.line_width = 0.5

          horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 20)
          horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 38)
          horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 55)
        end
        fill_color '000000'
        draw_text "ARMOR TYPE:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 15)]
        draw_text "#{@character.equipped_armor.armor.name unless @character.equipped_armor.nil?}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 15)]
        draw_text "MAKE / MODEL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 33)]
        if @character.equipped_armor && @character.equipped_armor.armor_model
          draw_text "#{@character.equipped_armor.armor_model.name unless @character.equipped_armor.nil?}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 33)]
        end
        draw_text "SEPCIAL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 50)]
        draw_text "#{@character.equipped_armor.description unless @character.equipped_armor.nil?}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 50)]
      end
      bounding_box([(bounds.left + ((bounds.width / 4) * 3)), bounds.top], width: ((bounds.width / 4)), height: 70) do
        fill_color '354555'
        polygon [(bounds.left),(bounds.top - 7)], [(bounds.left + 10),(bounds.top - 2)], [(bounds.right - 10),(bounds.top - 2)], [(bounds.right),(bounds.top - 7)], [(bounds.right - 10),(bounds.top - 12)], [(bounds.left + 10),(bounds.top - 12)]
        fill
        fill_color 'ffffff'
        text_box "CONDITION", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center

        rectangle [(bounds.left + 5), (bounds.top - 15)], 10, 10
        rectangle [(bounds.left + 5), (bounds.top - 30)], 10, 10
        rectangle [(bounds.left + 5), (bounds.top - 45)], 10, 10
        self.line_width = 1
        fill_and_stroke
        fill_color '000000'
        draw_text "MINOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 22)]
        draw_text "MODERATE", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 37)]
        draw_text "MAJOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 52)]

        fill_color "532380"
        polygon [(bounds.right - 8),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 15)], [(bounds.right),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 25)]
        #==
        polygon [(bounds.right - 8),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 30)], [(bounds.right),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 40)]
        polygon [(bounds.right - 17),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 30)], [(bounds.right - 9),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 40)]
        #==
        polygon [(bounds.right - 8),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 45)], [(bounds.right),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 55)]
        polygon [(bounds.right - 17),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 45)], [(bounds.right - 9),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 55)]
        polygon [(bounds.right - 26),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 45)], [(bounds.right - 18),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 55)]
        fill
      end
    end
    bounding_box([bounds.left, (bounds.top - 60)], width: bounds.width, height: 55) do
      fill_color 'FFFFFF'
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
      fill_and_stroke

      fill_color "6b6767"
      polygon [(bounds.left + 242),(bounds.top - 4)], [(bounds.left + 250),(bounds.top - 1)], [(bounds.right - 250),(bounds.top - 1)], [(bounds.right - 242),(bounds.top - 4)], [(bounds.right - 250),(bounds.top - 7)], [(bounds.left + 250),(bounds.top - 7)]
      fill
      fill_color 'ffffff'
      text_box "ATTACHMENTS", width: bounds.width, height: 9, size: 4, align: :center, valign: :center

      bounding_box([(bounds.left + 5), (bounds.top - 7)], width: (bounds.width - 10), height: 50) do
        fill_color '000000'
        table [
            ['NAME', 'HARD POINT REQ', 'BASE MODIFIERS', 'MODIFICATIONS']
          ],
          cell_style: {
            height: 9,
            padding: 1,
            size: 5,
            align: :center,
            border_width: 0,
            :font_style => :bold,
          },
          width: bounds.width,
          column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)]

        if @character.equipped_armor && @character.equipped_armor.character_armor_attachments
          modifications = @character.equipped_armor.character_armor_attachments.map do |attachment|
            armor_attachment = ArmorAttachment.find(attachment.armor_attachment_id)

            armor_attachment_text = Array.new
            if attachment.armor_attachment_modification_options
              attachment.armor_attachment_modification_options.each do |option|
                modification_option = ArmorAttachmentModificationOption.find(option)

                if modification_option.talent_id
                  armor_attachment_text << "Innate talent: #{Talent.find(modification_option.talent_id).name}"
                end
                if modification_option.skill_id
                  armor_attachment_text << "Skill bonus: #{Skill.find(modification_option.skill_id).name}"
                end
              end
            end

            [
              armor_attachment.name,
              armor_attachment.hard_points,
              armor_attachment.description,
              armor_attachment_text.join(', ')
            ]
          end
          if modifications.any?
          table(modifications,
            cell_style: {
              height: 9,
              padding: 1,
              border_width: 0,
              size: 5,
            },
            width: bounds.width,
            column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)],
            row_colors: %w[FFFFFF, C0C0C0]
            ) do
              column(0).style align: :left
              column(1).style align: :center
              column(2).style align: :left
            end
          end
        end
      end
    end
  end
  #===== /ARMOR =====

  #===== WEAPONS =====
  fill_color "244060"
  polygon [(bounds.left + 200),(bounds.top - 140)], [(bounds.left + 210),(bounds.top - 135)], [(bounds.right - 210),(bounds.top - 135)], [(bounds.right - 200),(bounds.top - 140)], [(bounds.right - 210),(bounds.top - 145)], [(bounds.left + 210),(bounds.top - 145)]
  fill
  fill_color 'ffffff'
  text_box "WEAPONS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center, at: [0, (bounds.top - 133)]
  bounding_box([bounds.left, (bounds.top - 146)], width: bounds.width, height: 360) do
    @character.equipped_weapons.first(3).each_with_index do |weapon, i|
      top_margin = 120
      rectangle_top_margin = 0
      bounding_box([bounds.left, (bounds.top - (top_margin * i))], width: bounds.width, height: 120) do
        bounding_box([bounds.left, bounds.top], width: ((bounds.width / 2)), height: 60) do
          fill_color "761114"
          rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
          fill

          # DAMAGE
          bounding_box([bounds.left, bounds.top], width: (bounds.width / 4), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "#{weapon.weapon.damage}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "DAMAGE", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # CRIT
          bounding_box([(bounds.left + ((bounds.width / 4) * 1)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "#{weapon.weapon.crit}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "CRIT", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # ENCUMBRANCE
          bounding_box([(bounds.left + ((bounds.width / 4) * 2)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "#{weapon.weapon.encumbrance}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "ENCUM", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # HARD POINTS
          bounding_box([(bounds.left + ((bounds.width / 4) * 3)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "#{weapon.weapon.hard_points}", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "HP", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
        end

        bounding_box([(bounds.left + (bounds.width / 2)), bounds.top], width: (bounds.width / 2), height: 60) do
          bounding_box([bounds.left, bounds.top], width: ((bounds.width / 4) * 3), height: bounds.height) do
            fill_color 'C0C0C0'
            rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
            fill_and_stroke
            fill_color 'FFFFFF'
            rounded_rectangle [(bounds.left + 2), (bounds.top - 2)], (bounds.width - 4), (bounds.height - 4), 4
            fill_and_stroke

            stroke do
              stroke_color "000000"
              self.line_width = 0.5

              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 20)
              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 38)
              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 55)
            end
            fill_color '000000'
            draw_text "WEAPON TYPE:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 15)]
            draw_text "#{weapon.weapon.name unless weapon.nil?}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 15)]
            draw_text "MAKE / MODEL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 33)]
            unless weapon.nil? || weapon.weapon_model.nil?
              draw_text "#{weapon.weapon_model.name}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 33)]
            end
            draw_text "SEPCIAL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 50)]
            draw_text "#{weapon.description unless weapon.nil?}", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 50)]
          end
          bounding_box([(bounds.left + ((bounds.width / 4) * 3)), bounds.top], width: ((bounds.width / 4)), height: 70) do
            fill_color '354555'
            polygon [(bounds.left),(bounds.top - 7)], [(bounds.left + 10),(bounds.top - 2)], [(bounds.right - 10),(bounds.top - 2)], [(bounds.right),(bounds.top - 7)], [(bounds.right - 10),(bounds.top - 12)], [(bounds.left + 10),(bounds.top - 12)]
            fill
            fill_color 'ffffff'
            text_box "CONDITION", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center

            rectangle [(bounds.left + 5), (bounds.top - 15)], 10, 10
            rectangle [(bounds.left + 5), (bounds.top - 30)], 10, 10
            rectangle [(bounds.left + 5), (bounds.top - 45)], 10, 10
            self.line_width = 1
            fill_and_stroke
            fill_color '000000'
            draw_text "MINOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 22)]
            draw_text "MODERATE", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 37)]
            draw_text "MAJOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 52)]

            fill_color "532380"
            polygon [(bounds.right - 8),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 15)], [(bounds.right),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 25)]
            #==
            polygon [(bounds.right - 8),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 30)], [(bounds.right),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 40)]
            polygon [(bounds.right - 17),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 30)], [(bounds.right - 9),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 40)]
            #==
            polygon [(bounds.right - 8),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 45)], [(bounds.right),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 55)]
            polygon [(bounds.right - 17),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 45)], [(bounds.right - 9),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 55)]
            polygon [(bounds.right - 26),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 45)], [(bounds.right - 18),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 55)]
            fill
          end
        end

        bounding_box([bounds.left, (bounds.top - 60)], width: bounds.width, height: 55) do
          fill_color 'FFFFFF'
          rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
          fill_and_stroke

          fill_color "6b6767"
          polygon [(bounds.left + 242),(bounds.top - 4)], [(bounds.left + 250),(bounds.top - 1)], [(bounds.right - 250),(bounds.top - 1)], [(bounds.right - 242),(bounds.top - 4)], [(bounds.right - 250),(bounds.top - 7)], [(bounds.left + 250),(bounds.top - 7)]
          fill
          fill_color 'ffffff'
          text_box "ATTACHMENTS", width: bounds.width, height: 9, size: 4, align: :center, valign: :center

          bounding_box([(bounds.left + 5), (bounds.top - 7)], width: (bounds.width - 10), height: 50) do
            fill_color '000000'
            table [
              ['NAME', 'HARD POINT REQ', 'BASE MODIFIERS', 'MODIFICATIONS']
            ],
            cell_style: {
              height: 9,
              padding: 1,
              size: 5,
              align: :center,
              border_width: 0,
              :font_style => :bold,
            },
            width: bounds.width,
            column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)]

            unless weapon.character_weapon_attachments.blank?
              modifications = weapon.character_weapon_attachments.map do |attachment|
                weapon_attachment = WeaponAttachment.find(attachment.weapon_attachment_id)

                weapon_attachment_text = Array.new
                unless attachment.weapon_attachment_modification_options.nil?
                  attachment.weapon_attachment_modification_options.each do |option|
                    modification_option = WeaponAttachmentModificationOption.find(option)

                    unless modification_option.talent_id.nil?
                      weapon_attachment_text << "Innate talent: #{Talent.find(modification_option.talent_id).name}"
                    end
                    unless modification_option.skill_id.nil?
                      weapon_attachment_text << "Skill bonus: #{Skill.find(modification_option.skill_id).name}"
                    end
                  end
                end

                [
                  weapon_attachment.name,
                  weapon_attachment.hard_points,
                  weapon_attachment.description,
                  weapon_attachment_text.join(', ')
                ]
              end

              table(modifications,
              cell_style: {
                height: 9,
                padding: 1,
                border_width: 0,
                size: 5,
              },
              width: bounds.width,
              column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)],
              row_colors: %w[FFFFFF, C0C0C0]
              ) do
                column(0).style align: :left
                column(1).style align: :center
                column(2).style align: :left
              end
            end
          end
        end
      end
    end

    #=== DUMMY COPIES TO FILL OUT THE PAGE ====
    (3 - @character.equipped_weapons.first(3).count).times do |i|
    end
    (3 - @character.equipped_weapons.first(3).count).times do |i|
      i = i + @character.equipped_weapons.first(3).count
      top_margin = 120
      rectangle_top_margin = 0
      bounding_box([bounds.left, (bounds.top - (top_margin * i))], width: bounds.width, height: 120) do
        bounding_box([bounds.left, bounds.top], width: ((bounds.width / 2)), height: 60) do
          fill_color "761114"
          rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
          fill

          # DAMAGE
          bounding_box([bounds.left, bounds.top], width: (bounds.width / 4), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "DAMAGE", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # CRIT
          bounding_box([(bounds.left + ((bounds.width / 4) * 1)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "CRIT", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # ENCUMBRANCE
          bounding_box([(bounds.left + ((bounds.width / 4) * 2)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "ENCUM", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
          # HARD POINTS
          bounding_box([(bounds.left + ((bounds.width / 4) * 3)), bounds.top], width: (bounds.width / 5), height: bounds.height) do
            fill_color 'ffffff'
            self.line_width = 2
            # Outer
            circle [(bounds.width / 2),(bounds.top - 25)], 22
            fill_and_stroke
            self.line_width = 1
            # Inner
            circle [(bounds.width / 2),(bounds.top - 25)], 20
            fill_and_stroke
            fill_color '000000'
            text_box "", size: 30, style: :bold, at: [bounds.left, (bounds.top + 2)], width: bounds.width, height: bounds.height, align: :center, valign: :center, overflow: :shrink_to_fit
            fill_color "52644B"
            rounded_rectangle [(bounds.left + 2), (bounds.bottom + 11)], (bounds.width - 4), 9, 5
            fill
            fill_color 'ffffff'
            text_box "HP", size: 6, style: :normal, at: [bounds.left, (bounds.bottom + 10)], width: bounds.width, height: 9, align: :center, valign: :center
            fill
          end
        end

        bounding_box([(bounds.left + (bounds.width / 2)), bounds.top], width: (bounds.width / 2), height: 60) do
          bounding_box([bounds.left, bounds.top], width: ((bounds.width / 4) * 3), height: bounds.height) do
            fill_color 'C0C0C0'
            rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
            fill_and_stroke
            fill_color 'FFFFFF'
            rounded_rectangle [(bounds.left + 2), (bounds.top - 2)], (bounds.width - 4), (bounds.height - 4), 4
            fill_and_stroke

            stroke do
              stroke_color "000000"
              self.line_width = 0.5

              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 20)
              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 38)
              horizontal_line (bounds.left + 4), (bounds.right - 4), at: (bounds.top - 55)
            end
            fill_color '000000'
            draw_text "WEAPON TYPE:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 15)]
            draw_text "", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 15)]
            draw_text "MAKE / MODEL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 33)]
            draw_text "", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 33)]
            draw_text "SEPCIAL:", size: 7, style: :normal, at: [(bounds.left + 4), (bounds.top - 50)]
            draw_text "", size: 7, style: :bold, at: [(bounds.left + 60), (bounds.top - 50)]
          end
          bounding_box([(bounds.left + ((bounds.width / 4) * 3)), bounds.top], width: ((bounds.width / 4)), height: 70) do
            fill_color '354555'
            polygon [(bounds.left),(bounds.top - 7)], [(bounds.left + 10),(bounds.top - 2)], [(bounds.right - 10),(bounds.top - 2)], [(bounds.right),(bounds.top - 7)], [(bounds.right - 10),(bounds.top - 12)], [(bounds.left + 10),(bounds.top - 12)]
            fill
            fill_color 'ffffff'
            text_box "CONDITION", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 5, style: :bold, align: :center, valign: :center

            rectangle [(bounds.left + 5), (bounds.top - 15)], 10, 10
            rectangle [(bounds.left + 5), (bounds.top - 30)], 10, 10
            rectangle [(bounds.left + 5), (bounds.top - 45)], 10, 10
            self.line_width = 1
            fill_and_stroke
            fill_color '000000'
            draw_text "MINOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 22)]
            draw_text "MODERATE", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 37)]
            draw_text "MAJOR", size: 5, style: :normal, at: [(bounds.left + 20), (bounds.top - 52)]

            fill_color "532380"
            polygon [(bounds.right - 8),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 15)], [(bounds.right),(bounds.top - 20)], [(bounds.right - 4),(bounds.top - 25)]
            #==
            polygon [(bounds.right - 8),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 30)], [(bounds.right),(bounds.top - 35)], [(bounds.right - 4),(bounds.top - 40)]
            polygon [(bounds.right - 17),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 30)], [(bounds.right - 9),(bounds.top - 35)], [(bounds.right - 13),(bounds.top - 40)]
            #==
            polygon [(bounds.right - 8),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 45)], [(bounds.right),(bounds.top - 50)], [(bounds.right - 4),(bounds.top - 55)]
            polygon [(bounds.right - 17),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 45)], [(bounds.right - 9),(bounds.top - 50)], [(bounds.right - 13),(bounds.top - 55)]
            polygon [(bounds.right - 26),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 45)], [(bounds.right - 18),(bounds.top - 50)], [(bounds.right - 22),(bounds.top - 55)]
            fill
          end
        end

        bounding_box([bounds.left, (bounds.top - 60)], width: bounds.width, height: 55) do
          fill_color 'FFFFFF'
          rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
          fill_and_stroke

          fill_color "6b6767"
          polygon [(bounds.left + 242),(bounds.top - 4)], [(bounds.left + 250),(bounds.top - 1)], [(bounds.right - 250),(bounds.top - 1)], [(bounds.right - 242),(bounds.top - 4)], [(bounds.right - 250),(bounds.top - 7)], [(bounds.left + 250),(bounds.top - 7)]
          fill
          fill_color 'ffffff'
          text_box "ATTACHMENTS", width: bounds.width, height: 9, size: 4, align: :center, valign: :center

          bounding_box([(bounds.left + 5), (bounds.top - 7)], width: (bounds.width - 10), height: 50) do
            fill_color '000000'
            table [
              ['NAME', 'HARD POINT REQ', 'BASE MODIFIERS', 'MODIFICATIONS']
            ],
            cell_style: {
              height: 9,
              padding: 1,
              size: 5,
              align: :center,
              border_width: 0,
              :font_style => :bold,
            },
            width: bounds.width,
            column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)]

              modifications = 1.times.map do |attachment|
                [
                  '',
                  '',
                  '',
                  ''
                ]
              end

              table(modifications,
              cell_style: {
                height: 9,
                padding: 1,
                border_width: 0,
                size: 5,
              },
              width: bounds.width,
              column_widths: [100, 50, ((bounds.width - 150) / 2), ((bounds.width - 150) / 2)],
              row_colors: %w[FFFFFF, C0C0C0]
              ) do
                column(0).style align: :left
                column(1).style align: :center
                column(2).style align: :left
              end
            end
        end
      end
    end
    #=== /DUMMY COPIES TO FILL OUT THE PAGE ===
  end
  #===== /WEAPONS =====

  #===== CYBERNETICS =====
  bounding_box([bounds.left, (bounds.bottom + 335)], width: bounds.width, height: 270) do
    fill_color 'C0C0C0'
    rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
    fill_and_stroke

    fill_color '354555'
    polygon [(bounds.left + 200),(bounds.top - 7)], [(bounds.left + 210),(bounds.top - 2)], [(bounds.right - 210),(bounds.top - 2)], [(bounds.right - 200),(bounds.top - 7)], [(bounds.right - 210),(bounds.top - 12)], [(bounds.left + 210),(bounds.top - 12)]
    fill
    fill_color 'ffffff'
    text_box "CYBERNETICS", width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
    fill_color '000000'

    bounding_box([(bounds.left + 5), (bounds.top - 10)], width: (bounds.width - 10)) do
      table [
       ['MAKE/MODEL', 'LOCATION', 'BONUS']
      ],
      cell_style: {
        height: 10,
        padding: [2, 3],
        size: 5,
        align: :left,
        border_width: 0,
      },
      width: bounds.width,
      column_widths: {0 => 150, 1 => 100}

      cybernetics = Array.new
      arm_bonus_set = nil
      leg_bonus_set = nil

      @character.cybernetics[:items].each do |cyb|
        bonus_active = false
        if arm_bonus_set.nil? && (cyb[:location] == 'left_arm' || cyb[:location] == 'right_arm')
          arm_bonus_set = true
          bonus_active = true
        elsif leg_bonus_set.nil? && (cyb[:location] == 'left_leg' || cyb[:location] == 'right_leg') && @character.cybernetics[:legs]
          leg_bonus_set = true
          bonus_active = true
        end
        unless cyb[:location] =~ /(_leg)|(_arm)/
          bonus_active = true
        end

        cybernetics << [cyb[:name], cyb[:location].humanize, (cyb[:bonus].map{|k,v| "#{k.to_s.humanize} +#{v}"}.join(' & ') if bonus_active)]
      end

      if cybernetics.any?
        table cybernetics,
        cell_style: {
          #:background_color => "FFFFFF",
          height: 12,
          padding: [2, 3],
          size: 6,
          border_width: 1,
          },
          width: bounds.width,
          column_widths: {0 => 150, 1 => 100},
          row_colors: %w[FFFFFF, C0C0C0]
      end
    end
  end
  #===== /CYBERNETICS =====

  #===== FOOTER =====
  bounding_box([bounds.left, (bounds.bottom + 45)], width: bounds.width, height: 45) do
    #fill_color 'C0C0C0'
    #rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
    #fill

    bounding_box([(bounds.left + 100), (bounds.bottom + 45)], width: (bounds.width - 200), height: 45) do
      fill_color '751010'
      rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
      fill

      fill_color 'ffffff'
      text_box "ARMOR / WEAPONS / CYBERNETICS SHEET", at: [bounds.left, bounds.top], width: bounds.width, height: bounds.height, size: 15, style: :bold, align: :center, valign: :center
    end

  end
  #===== /FOOTER =====

  start_new_page
end

  def page_4
    # ===== Personal finances =====
    bounding_box([bounds.left, bounds.top], width: bounds.width, height: 50) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
      fill

      fill_color '354555'
      polygon [(bounds.left + 200), (bounds.top - 7)],
              [(bounds.left + 210), (bounds.top - 2)],
              [(bounds.right - 210), (bounds.top - 2)],
              [(bounds.right - 200), (bounds.top - 7)],
              [(bounds.right - 210), (bounds.top - 12)],
              [(bounds.left + 210), (bounds.top - 12)]
      fill
      fill_color 'ffffff'
      text_box 'PERSONAL FINANCES', width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      fill_color '000000'

      bounding_box([(bounds.left + 10), (bounds.top - 12)], width: 150, height: (bounds.height - 7)) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left, (bounds.bottom + 13)],
                  [bounds.left, (bounds.top - 13)],
                  [(bounds.left + 15), bounds.top],
                  [(bounds.right - 15), bounds.top],
                  [bounds.right, (bounds.top - 13)],
                  [bounds.right, (bounds.bottom + 13)],
                  [(bounds.right - 15), (bounds.bottom + 2)],
                  [(bounds.left + 15), (bounds.bottom + 2)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 11), (bounds.bottom + 9)],
                [(bounds.left + 17), (bounds.bottom + 4)],
                [(bounds.right - 17), (bounds.bottom + 4)],
                [(bounds.right - 11), (bounds.bottom + 9)],
                [(bounds.right - 17), (bounds.bottom + 13)],
                [(bounds.left + 17), (bounds.bottom + 13)]
        fill
        fill_color 'ffffff'
        text_box 'CREDITS', at: [bounds.left, (bounds.bottom + 12)], width: bounds.width, height: 8, overflow: :shrink_to_fit, size: 6, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box "#{@character.credits}", at: [bounds.left, (bounds.top)], width: bounds.width, height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
      end

    end
    # ===== /Personal Finances =====

    # ===== Carried equipment =====
    bounding_box([bounds.left, (bounds.top - 65)], width: bounds.width, height: 350) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
      fill

      fill_color '354555'
      polygon [(bounds.left + 200), (bounds.top - 7)],
              [(bounds.left + 210), (bounds.top - 2)],
              [(bounds.right - 210), (bounds.top - 2)],
              [(bounds.right - 200), (bounds.top - 7)],
              [(bounds.right - 210), (bounds.top - 12)],
              [(bounds.left + 210), (bounds.top - 12)]
      fill
      fill_color 'ffffff'
      text_box 'WORN / GENERALLY CARRIED', width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      fill_color '000000'

      bounding_box([(bounds.left + 10), (bounds.top - 20)], width: (bounds.width / 5), height: 50) do
        # Outer Box.
        stroke do
          self.line_width = 2
          fill_color 'ffffff'
          stroke_color '474D46'
          polygon [bounds.left, (bounds.top - 43)],
                  [bounds.left, (bounds.top - 8)],
                  [(bounds.left + 14), bounds.top],
                  [(bounds.right - 14), bounds.top],
                  [bounds.right, (bounds.top - 8)],
                  [bounds.right, (bounds.top - 43)],
                  [(bounds.right - 14), (bounds.top - 53)],
                  [(bounds.left + 14), (bounds.top - 53)]
          fill_and_stroke
        end
        # Label box.
        fill_color '354555'
        polygon [(bounds.left + 2), (bounds.top - 9)],
                [(bounds.left + 14), (bounds.top - 2)],
                [(bounds.right - 14), (bounds.top - 2)],
                [(bounds.right - 2), (bounds.top - 9)],
                [(bounds.right - 14), (bounds.top - 16)],
                [(bounds.left + 14), (bounds.top - 16)]
        fill
        fill_color 'ffffff'
        text_box 'ENCUMBRANCE', at: [bounds.left, bounds.top], width: bounds.width, height: 16, overflow: :shrink_to_fit, size: 10, style: :bold, align: :center, valign: :bottom
        fill_color '000000'
        text_box @character.encumbrance_threshold.to_s, at: [bounds.left, (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        text_box @character.encumbrance_value.to_s, at: [(bounds.left + 50), (bounds.top - 18)], width: (bounds.width / 2), height: 36, overflow: :shrink_to_fit, size: 25, style: :bold, align: :center, valign: :center
        line [(bounds.width / 2), (bounds.top - 16)], [(bounds.width / 2), (bounds.top - 52)]
        fill
        text_box 'THRESHOLD', at: [bounds.left, (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
        text_box 'CURRENT', at: [(bounds.width / 2), (bounds.top - 55)], width: (bounds.width / 2), height: 10, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      end

      inventory_carried = @character.inventory(carried: true)

      if inventory_carried.any?
        items_left = inventory_carried[0..16].map do |item|
          font 'Helvetica', size: 8
          [
            item[:name],
            item[:quantity],
            item[:total_encumbrance],
            item[:location]
          ]
        end

        (21 - items_left.count).times do
          items_left << ['', '', '', '']
        end

        items_right = inventory_carried.drop(17).map do |item|
          font 'Helvetica', size: 8
          [
            item[:name],
            item[:quantity],
            item[:total_encumbrance],
            item[:location]
          ]
        end

        (26 - items_right.count).times do
          items_right << ['', '', '', '']
        end

        bounding_box([(bounds.left + 10), (bounds.top - 85)], width: ((bounds.width / 2) - 20), height: bounds.height) do
          table [['ITEM', 'QTY', 'ENCUMB.', 'LOCATION']],
                cell_style: {
                  height: 10,
                  padding: [2, 3],
                  size: 5,
                  align: :left,
                  border_width: 0
                },
                width: 257,
                column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 }

          if items_left.any?
            table items_left,
                  cell_style: {
                    height: 12,
                    padding: [2, 3],
                    size: 6,
                    border_width: 1
                  },
                  width: 257,
                  column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 },
                  row_colors: %w(FFFFFF, C0C0C0)
          end
        end

        bounding_box([(bounds.left + (bounds.width / 2) + 10), (bounds.top - 25)], width: ((bounds.width / 2) - 20), height: bounds.height) do
          table [['ITEM', 'QUANTITY', 'ENCUMB.', 'LOCATION']],
                cell_style: {
                  height: 10,
                  padding: [2, 3],
                  size: 5,
                  align: :left,
                  border_width: 0
                },
                width: 257,
                column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 }

          if items_right.any?
            table items_right,
                  cell_style: {
                    height: 12,
                    padding: [2, 3],
                    size: 6,
                    border_width: 1
                  },
                  width: 257,
                  column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 },
                  row_colors: %w(FFFFFF, C0C0C0)
          end
        end
      end
    end
    # ===== /Carried equipment =====

    # ===== Other property =====
    bounding_box([bounds.left, (bounds.top - 430)], width: bounds.width, height: 350) do
      fill_color 'C0C0C0'
      rounded_rectangle [bounds.left, (bounds.top - 7)], bounds.width, bounds.height, 5
      fill

      fill_color '354555'
      polygon [(bounds.left + 200), (bounds.top - 7)],
              [(bounds.left + 210), (bounds.top - 2)],
              [(bounds.right - 210), (bounds.top - 2)],
              [(bounds.right - 200), (bounds.top - 7)],
              [(bounds.right - 210), (bounds.top - 12)],
              [(bounds.left + 210), (bounds.top - 12)]
      fill
      fill_color 'ffffff'
      text_box 'OTHER PROPERTY', width: bounds.width, height: 15, overflow: :shrink_to_fit, size: 7, style: :bold, align: :center, valign: :center
      fill_color '000000'

      inventory_other = @character.inventory(carried: false)

      items_left = inventory_other[0..25].map do |item|
        font 'Helvetica', size: 8
        [
          item[:name],
          item[:quantity],
          item[:total_encumbrance],
          item[:location]
        ]
      end

      (26 - items_left.count).times do
        items_left << ['', '', '', '']
      end

      items_right = inventory_other.drop(26).map do |item|
        font 'Helvetica', size: 8
        [
          item[:name],
          item[:quantity],
          item[:total_encumbrance],
          item[:location]
        ]
      end

      (26 - items_right.count).times do
        items_right << ['', '', '', '']
      end

      bounding_box([(bounds.left + 10), (bounds.top - 25)], width: ((bounds.width / 2) - 20), height: bounds.height) do
        table [['ITEM', 'QTY', 'ENCUMB.', 'LOCATION']],
              cell_style: {
                height: 10,
                padding: [2, 3],
                size: 5,
                align: :left,
                border_width: 0
              },
              width: 257,
              column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 }

        if items_left.any?
          table items_left,
                cell_style: {
                  height: 12,
                  padding: [2, 3],
                  size: 6,
                  border_width: 1
                },
                width: 257,
                column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 },
                row_colors: %w(FFFFFF, C0C0C0)
        end
      end

      bounding_box([(bounds.left + (bounds.width / 2) + 10), (bounds.top - 25)], width: ((bounds.width / 2) - 20), height: bounds.height) do
        table [['ITEM', 'QUANTITY', 'ENCUMB.', 'LOCATION']],
              cell_style: {
                height: 10,
                padding: [2, 3],
                size: 5,
                align: :left,
                border_width: 0
              },
              width: 257,
              column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 }

        if items_right.any?
          table items_right,
                cell_style: {
                  height: 12,
                  padding: [2, 3],
                  size: 6,
                  border_width: 1
                },
                width: 257,
                column_widths: { 0 => 125, 1 => 30, 2 => 30, 3 => 72 },
                row_colors: %w(FFFFFF, C0C0C0)
        end
      end
    end
    # ===== /Other property =====

    # ===== FOOTER =====
    bounding_box([bounds.left, (bounds.bottom + 45)], width: bounds.width, height: 45) do
      bounding_box([(bounds.left + 100), (bounds.bottom + 45)], width: (bounds.width - 200), height: 45) do
        fill_color '751010'
        rounded_rectangle [bounds.left, bounds.top], bounds.width, bounds.height, 5
        fill

        fill_color 'ffffff'
        text_box 'PERSONAL ACQUISITIONS SHEET', at: [bounds.left, bounds.top], width: bounds.width, height: bounds.height, size: 15, style: :bold, align: :center, valign: :center
      end
    end
    # ===== /FOOTER =====
  end
end
