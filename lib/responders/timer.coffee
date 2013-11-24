class Responder extends Bitbot.BaseResponder

  responderName: "Timers"
  responderDesc: "I'll set a timer for you."

  commandPrefix: "timer"

  commands:
    create:
      desc: "Creates a timer"
      examples: ["set a timer for 4 minutes.", "timebox this to 30 minutes."]
      intent: "timercreate"
      opts:
        duration: {type: "integer", default: 300}

  templates:
    set: "Okay {{initials}}, I've set a timer for {{duration}}."
    done: "⌚ Okay {{name}}, your timer's done."


  create: (duration, callback) ->
    @delay(duration * 1000, => callback(speak: @t('done')))
    speak: @t('set', duration: @humanDuration(duration))



module.exports = new Responder()
