SILE.registerCommand("imprint:font", function (options, content)
  options.weight = options.weight or 400
  options.size = options.size or "9pt"
  options.language = options.language or "und"
  options.family = options.family or "Libertinus Serif"
  SILE.call("font", options, content)
end)

SILE.registerCommand("imprint", function (options, content)
  SILE.settings.temporarily(function ()
    local imgUnit = SILE.length.parse("1em")
    SILE.settings.set("document.lskip", SILE.nodefactory.zeroGlue)
    SILE.settings.set("document.rskip", SILE.nodefactory.zeroGlue)
    SILE.settings.set("document.rskip", SILE.nodefactory.zeroGlue)
    SILE.settings.set("document.parskip", SILE.nodefactory.newVglue("1.2ex"))
    SILE.call("nofolios")
    SILE.call("noindent")
    SILE.call("topfill")
    SILE.call("raggedright", {}, function ()
      SILE.call("imprint:font", {}, function ()
        SILE.settings.set("linespacing.method", "fixed")
        SILE.settings.set("linespacing.fixed.baselinedistance", SILE.length.parse("2.8ex plus 1pt minus 0.5pt"))

        if CASILE.metadata.publisher and not SILE.scratch.layout == "app" then
          SILE.settings.temporarily(function ()
            SILE.call("skip", { height = "-6.7em" })
            SILE.settings.set("document.lskip", SILE.nodefactory.newGlue({ width = imgUnit * 6.5 }))
            SILE.call("break")
            SILE.typesetter:typeset("Davutpaşa Cad. Kazım Dinçol San. Sit.")
            SILE.call("break")
            SILE.typesetter:typeset("No 81/87, Topkapı, İstanbul, Türkiye")
            SILE.call("break")
            SILE.call("font", { family = "Hack", size = "0.8em" }, function ()
              SILE.typesetter:typeset("https://viachristus.com")
              SILE.call("break")
              SILE.typesetter:typeset("yayinlar@viachristus.com")
            end)
            SILE.call("par")
          end)
        end

        if SILE.Commands["meta:title"] then
          SILE.call("font", { weight = 600, style = "Bold" }, SILE.Commands["meta:title"])
          SILE.call("break")
        end
        if SILE.Commands["meta:creators"] then SILE.call("meta:creators") end
        if SILE.Commands["meta:info"] then
          SILE.call("meta:info")
          SILE.call("par")
        end
        if SILE.Commands["meta:source"] then
          SILE.call("meta:source")
          SILE.call("par")
        end
        if SILE.Commands["meta:rights"] then
          SILE.call("meta:rights")
          SILE.call("par")
        end

        if CASILE.metadata.manufacturer then
          SILE.call("skip", { height = "5.4em" })
          SILE.settings.temporarily(function ()
            SILE.call("img", { src = qrimg, height = "5.8em" })
            SILE.call("skip", { height = "-6.3em" })
            SILE.settings.set("document.lskip", SILE.nodefactory.newGlue({ width = imgUnit * 6.5 }))
            if SILE.Commands["meta:identifiers"] then SILE.call("meta:identifiers") end
            SILE.call("font", { weight = 600, style = "Bold" }, { "Sürüm: " })
            SILE.call("font", { family = "Hack", size = "0.8em" }, SILE.Commands["meta:surum"])
            SILE.call("break")
            SILE.call("font", { weight = 600, style = "Bold" }, { "URL: " })
            SILE.call("font", { family = "Hack", size = "0.8em" }, SILE.Commands["meta:url"])
            -- Hack around not being able to output a vbox with an indent
            -- See https://github.com/simoncozens/sile/issues/318
            local lines = 1
            for i = 1, #SILE.typesetter.state.nodes do
              lines = lines + (SILE.typesetter.state.nodes[i]:isPenalty() and 1 or 0)
            end
            for i = lines, 5 do
              SILE.call("hbox")
              SILE.call("break")
            end
            SILE.call("par")
          end)
        else
          SILE.call("font", { weight = 600, style = "Bold" }, { "Sürüm: " })
          SILE.call("font", { family = "Hack", size = "0.8em" }, SILE.Commands["meta:surum"])
          SILE.call("par")
        end

        if SILE.Commands["meta:contributors"] then
          SILE.call("meta:contributors")
          SILE.call("par")
        end
        if SILE.Commands["meta:extracredits"] then
          SILE.call("meta:extracredits")
          SILE.call("par")
        end
        if SILE.Commands["meta:versecredits"] then
          SILE.call("meta:versecredits")
        end
        if CASILE.metadata.publisher then
          if SILE.Commands["meta:distribution"] then
            SILE.call("par")
            SILE.call("meta:distribution")
          elseif SILE.Commands["meta:date"] then
            SILE.call("par")
            SILE.call("meta:manufacturer")
            SILE.call("par")
            SILE.call("meta:date")
          end
        end
        SILE.call("par")
      end)
    end)
  end)
  SILE.call("par")
  SILE.call("break")
end)
