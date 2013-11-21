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
        duration: {type: "integer", default: 300, note: "seconds"}

  create: (duration, callback) ->
    callback(speak: "⌚ Okay #{@message.user.initials}, I've set a timer for #{@friendlyDuration(duration)}.")

    name = @message.user.name
    @delay duration * 1000, ->
      callback(speak: "Okay #{name}, you're timer's done.")


  delay: (time, callback) ->
    setTimeout(callback, time)


  friendlyDuration: (seconds) ->
    pluralize = (n, str) -> if (n > 1) then "#{n} #{str}s" else "#{n} #{str}"

    return pluralize(years, 'year') if years = Math.floor(seconds / 31536000)
    return pluralize(days, 'day') if days = Math.floor((seconds %= 31536000) / 86400)
    return pluralize(hours, 'hour') if hours = Math.floor((seconds %= 86400) / 3600)
    return pluralize(minutes, 'minute') if minutes = Math.floor((seconds %= 3600) / 60)
    return pluralize(seconds, 'second') if seconds = seconds % 60
    return "now"

module.exports = new Responder()
