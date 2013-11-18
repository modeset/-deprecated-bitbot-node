class Responder extends Bitbot.BaseResponder

  responderName: "Timers"
  responderDesc: "I'll set a timer for you."

  commandPrefix: "timer"

  commands:
    create:
      desc: "Creates a timer"
      examples: ["set a timer for 4 minutes", "timebox this to 30 minutes"]
      intent: "timercreate"
      opts:
        duration: type: "integer", default: 300, note: "seconds"

  create: (duration, callback) ->
    callback(speak: "⌚ Okay #{@message.user.initials}, I've set a timer for #{duration} seconds.")

    name = @message.user.name
    @delay duration * 1000, ->
      callback(speak: "Okay #{name}, you're timer's done.")


  delay: (time, callback) ->
    setTimeout(callback, time)


module.exports = new Responder()
