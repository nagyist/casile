return function (class)

  class.options.papersize = "135mm x 195mm"

  if class._name == "cabook" then

    class.defaultFrameset = {
      content = {
        left = "22.5mm",
        right = "100%pw-15mm",
        top = "20mm",
        bottom = "top(footnotes)"
      },
      runningHead = {
        left = "left(content)",
        right = "right(content)",
        top = "top(content)-8mm",
        bottom = "top(content)-2mm"
      },
      footnotes = {
        left = "left(content)",
        right = "right(content)",
        height = "0",
        bottom = "100%ph-18mm"
      },
      folio = {
        left = "left(content)",
        right = "right(content)",
        top = "100%ph-12mm",
        height = "6mm"
      }
    }

    class:loadPackage("masters", {{
      id = "right",
      firstContentFrame = "content",
      frames = class.defaultFrameset
    }})

    class:loadPackage("twoside", {
      oddPageMaster = "right",
      evenPageMaster = "left"
    })

    SILE.setCommandDefaults("imprint:font", { size = "8.5pt" })

    -- Hack to avoid SILE bug in print editions
    -- See https://github.com/simoncozens/sile/issues/355
    class:registerCommand("href", function (options, content)
      if class.options.verseindex then
        SILE.call("markverse", options, content)
      end
      SILE.process(content)
    end)

  end

end
