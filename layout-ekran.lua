CASILE.layout = "ekran"

local class = SILE.documentState.documentClass

SILE.documentState.paperSize = SILE.paperSizeParser(1280 / 96 .. "in x " .. 800 / 96 .. "in")
SILE.documentState.orgPaperSize = SILE.documentState.paperSize

class:defineMaster({
    id = "right",
    firstContentFrame = "content",
    frames = {
      page = {
        left = "0",
        right = "100%pw",
        top = "0",
        bottom = "100%ph"
      },
      content = {
        left = "5%pw",
        right = "100%pw-5%pw",
        top = "bottom(runningHead)+1%ph",
        bottom = "top(footnotes)-1%ph"
      },
      runningHead = {
        left = "left(content)",
        right = "right(content)",
        top = "2%ph",
        bottom = "5%ph"
      },
      footnotes = {
        left = "left(content)",
        right = "right(content)",
        height = "0",
        bottom = "100%ph-5%ph"
      }
    }
  })
class:mirrorMaster("right", "left")
SILE.call("switch-master-one-page", { id = "right" })

SILE.registerCommand("output-right-running-head", function (options, content)
  if not SILE.scratch.headers.right then return end
  SILE.typesetNaturally(SILE.getFrame("runningHead"), function ()
    SILE.settings.set("current.parindent", SILE.nodefactory.zeroGlue)
    SILE.settings.set("typesetter.parfillskip", SILE.nodefactory.zeroGlue)
    SILE.settings.set("document.lskip", SILE.nodefactory.zeroGlue)
    SILE.settings.set("document.rskip", SILE.nodefactory.zeroGlue)
    SILE.call("cabook:right-running-head-font", {}, function ()
      SILE.call("center", {}, function()
        SILE.call("meta:title")
      end)
    end)
    SILE.call("skip", { height = "2pt" })
    SILE.call("cabook:right-running-head-font", {}, SILE.scratch.headers.right)
    SILE.call("hfill")
    SILE.call("cabook:page-number-font", {},  { SILE.formatCounter(SILE.scratch.counters.folio) })
    SILE.call("skip", { height = "-8pt" })
    SILE.call("fullrule", { raise = 0 })
  end)
end)

SILE.registerCommand("output-left-running-head", function (options, content)
  SILE.call("output-right-running-head")
end)

-- Screen based PDF readers don't need blank even numbered pages ;)
SILE.registerCommand("open-double-page", function ()
  SILE.typesetter:leaveHmode();
  SILE.Commands["supereject"]();
  SILE.typesetter:leaveHmode();
end)

local origToc = SILE.Commands["tableofcontents"]
SILE.registerCommand("tableofcontents", function (options, content)
  SILE.scratch.headers.skipthispage = true
  origToc(options, content)
  SILE.scratch.headers.right = {}
end)

if SILE.documentState.documentClass.options.background() == "true" then
  SILE.require("packages/background")
  SILE.call("background", { color = "#efe6bf" })

  local inkColor = SILE.colorparser("#262d2c")
  SILE.outputter:pushColor(inkColor)
end
