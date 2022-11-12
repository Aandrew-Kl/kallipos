function Image(img)
    if img.classes:find('complexity',1) then
      local f = io.open("complexity/" .. img.src, 'r')
      local doc = pandoc.read(f:read('*a'))
      f:close()
      local duration = pandoc.utils.stringify(doc.meta.duration) or "Duration has not been set"
      local level = pandoc.utils.stringify(doc.meta.level) or "Level has not been set"
      local complexity = "Proteinomenos xronos: **" .. duration .. "**, Epipedo diskolias: **" .. level .. "**"
      return pandoc.RawInline('markdown',complexity)
    end
end
