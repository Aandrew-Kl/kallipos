function Image(img)
    if img.classes:find('complexity',1) then
      local f = io.open("complexity/" .. img.src, 'r')
      local doc = pandoc.read(f:read('*a'))
      f:close()
      local duration = pandoc.utils.stringify(doc.meta.duration) or "Duration has not been set"
      local level = pandoc.utils.stringify(doc.meta.level) or "Level has not been set"
      local wordcount = pandoc.utils.stringify(doc.meta.words) or "Word count has not been set"

      local complexity = "> Προτεινόμενος χρόνος: **" .. duration .. "**, Επίπεδο δυσκολίας: **" .. level .. "**\n"
      complexity = complexity .. "> Μέγεθος: **" .. wordcount .. "** λέξεις \n\n" .. " _ _ _ _ _"
      return pandoc.RawInline('markdown',complexity)
    end
end


--    Προτεινόμενος χρόνος     Επίπεδο δυσκολίας     Μέγεθος
--  ------------------------  --------------------  ----------
--        
