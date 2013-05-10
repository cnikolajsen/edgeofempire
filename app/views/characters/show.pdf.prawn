
#===== Character details =====
fill_color("6d7b68")
pdf.draw_text("CHARACTER", :size => 7, :style => :bold, :at => [74, y - 22])
fill_color("505b4d")
pdf.draw_text("CHARACTER NAME", :size => 11, :style => :bold, :at => [74, y - 39])
pdf.draw_text("SPECIES", :size => 7, :at => [74, y - 58])
pdf.draw_text("CAREER", :size => 7, :at => [74, y - 76])
pdf.draw_text("SPECIALIZATION TREES", :size => 7, :at => [74, y - 95])
fill_color("3e463b")
pdf.draw_text("#{@character.name}", :size => 14, :at => [195, y - 39])
pdf.draw_text("#{@character.race.name}", :size => 10, :at => [195, y - 58])
pdf.draw_text("#{@character.career.name}", :size => 10, :at => [195, y - 76])
pdf.text_box("#{@character.user.email}", :size => 8, :at => [458, y - 90])
#===== /Character details =====

