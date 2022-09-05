return function (class)

  class.options.papersize = "84mm x 52mm"

  if class._name == "cabook" then

    class.defaultFrameset = {
      content = {
        left = "5mm",
        right = "100%pw-5mm",
        top = "5mm",
        bottom = "100%ph-5mm"
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

    class:loadPackage("crop", {
      bleed = SILE.length("2.5mm").length,
      trim = SILE.length("5mm").length
    })

    class:registerCommand("output-right-running-head", function () end)

    class:registerCommand("output-left-running-head", function () end)

    -- Card layouts don’t need blanks of any kind.
    class:registerCommand("open-spread", function ()
      SILE.typesetter:leaveHmode()
      SILE.call("supereject")
      SILE.typesetter:leaveHmode()
    end)

    SILE.setCommandDefaults("imprint:font", { size = "5pt" })

  end

end
