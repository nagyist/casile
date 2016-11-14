SILE.scratch.layout = "app"

local class = SILE.documentState.documentClass
class:declareFrame("content", { left = "2mm", right = "100%pw-2mm", top = "16mm", bottom = "top(footnotes)" })
class:declareFrame("runningHead",  { left = "left(content)", right = "right(content)", top = "top(content)-14mm", bottom = "top(content)-2mm" })
class:declareFrame("footnotes", { left = "left(content)", right = "right(content)", bottom = "100%ph-2mm", height = "0" })

SILE.registerCommand("book:right-running-head", function (options, content)
  SILE.settings.set("current.parindent", SILE.nodefactory.zeroGlue)
  SILE.settings.set("typesetter.parfillskip", SILE.nodefactory.zeroGlue)
  SILE.settings.set("document.lskip", SILE.nodefactory.zeroGlue)
  SILE.settings.set("document.rskip", SILE.nodefactory.zeroGlue)
  SILE.call("book:left-running-head-font", {}, function ()
    SILE.call("center", {}, function()
      SILE.call("meta:title")
    end)
  end)
  SILE.call("skip", { height = "2pt" })
  SILE.call("book:right-running-head-font", {}, SILE.scratch.headers.right)
  SILE.call("hfill")
  SILE.call("book:page-number-font", {}, { SILE.formatCounter(SILE.scratch.counters.folio) })
  SILE.call("skip", { height = "-4pt" })
  SILE.call("fullrule")
end)

SILE.registerCommand("book:left-running-head", function (options, content)
  SILE.call("book:right-running-head")
end)

local oldImprintFont = SILE.Commands["imprint:font"]
SILE.registerCommand("imprint:font", function (options, content)
  options.size = options.size or "6.5pt"
  oldImprintFont(options, content)
end)

SILE.registerCommand("meta:distribution", function (options, content)
  SILE.call("font", { weight = 600, style = "Bold" }, { "Yayın: " })
  SILE.typesetter:typeset("Bu PDF biçimi, akıl telefon cihazlar için uygun biçimlemiştir ve Fetiye Halk Kilise’nin hazırladığı Kilise Uygulaması içinde ve Via Christus’un internet sitesinde izinle üçretsiz yayılmaktadır.")
end)

-- Mobile device PDF readers don't need blank even numbered pages ;)
SILE.registerCommand("open-double-page", function ()
  SILE.typesetter:leaveHmode();
  SILE.Commands["supereject"]();
  SILE.typesetter:leaveHmode();
end)

-- Forgo bottom of page layouts for mobile devices
SILE.registerCommand("topfill", function (options, content)
end)

SILE.require("packages/background")
SILE.call("background", { color = "#e9d8ba" })

local inkColor = SILE.colorparser("#5a4129")
SILE.outputter:pushColor(inkColor)
