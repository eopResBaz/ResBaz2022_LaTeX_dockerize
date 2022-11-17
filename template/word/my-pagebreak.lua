-- insert page break before every level 1 header
-- intended use for tex input, docx output

function Pandoc(doc)
  local hblocks = {}
  for i,el in pairs(doc.blocks) do
      if (el.t == "Header" and el.level == 1) then
         pandoc.List.insert(hblocks,
            pandoc.RawBlock(
              'openxml',
              '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'
            ))
      end
      pandoc.List.insert(hblocks, el)
  end
  return pandoc.Pandoc(hblocks, doc.meta)
end