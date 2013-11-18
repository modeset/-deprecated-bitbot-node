class Responder extends Bitbot.BaseResponder

  responderName: "Reminders"
  responderDesc: "Tell me to remind you about something, and I'll keep track of it and remind you."

  commandPrefix: "reminder"

  intervals:
    remind: 60 * 1000

  commands:
    create:
      desc: "Creates a reminder for yourself"
      examples: ["remind me to call Janet on friday at noon", "create reminder to deliver a package tomorrow"]
      intent: "reminder" # todo: should be remindercreate when wit allows changing this
      opts:
        reminder: {type: "string"}
        datetime: {type: "string"}
        location: {type: "string"}

    list:
      desc: "Lists your upcoming reminders"
      examples: ["list my reminders", "reminders?", "what are my tasks today?", "what do I have going on?"]
      intent: "reminderlist"

  clockMap:
    1:  "🕐", 130:  "🕜"
    2:  "🕑", 230:  "🕝"
    3:  "🕒", 330:  "🕞"
    4:  "🕓", 430:  "🕟"
    5:  "🕔", 530:  "🕠"
    6:  "🕕", 630:  "🕡"
    7:  "🕖", 730:  "🕢"
    8:  "🕗", 830:  "🕣"
    9:  "🕘", 930:  "🕤"
    10: "🕙", 1030: "🕥"
    11: "🕚", 1130: "🕦"
    12: "🕛", 1230: "🕧"

  remind: ->
    console.log('checking for reminders')


  create: (reminder, datetime, location) ->
    return {speak: "Sorry #{@message.user.name}, you need to provide something to remind you about."} unless reminder
    return {speak: "Sorry #{@message.user.initials}, I got that want a reminder to \"#{reminder}\", but you didn't provide a time."} unless datetime
    reminder = @processPossessives(reminder)
    time = datetime.from

    try
      msg = "I'll remind you to \"#{reminder}\", on #{@displayableTime(time)}."
      msg += " Location: #{@processPossessives(location)}." if location
      speak: "⏰ #{@message.user.name}, here's your reminder: #{msg}\n❓ Do you want me to create this?"
      confirm:
        callback: (confirmed, message) =>
          return {speak: "Ok #{message.user.name}, I didn't create it."} unless confirmed
          # todo: this should actually save something
          speak: "#{message.user.initials}, I've created the reminder for #{@displayableTime(time, "MMM Do [at] h:mm a")}. (or would've if this feature was complete)."
    catch e
      @log(e, 'error')
      speak: "Sorry #{message.user.initials}, but something went wrong."


  list: (callback) ->
    speak: "🕐 I should list your reminders, but the feature isn't complete."


  displayableTime: (time, format = 'dddd, MMMM Do [at] h:mm a') ->
    Moment(time).format(format);

  processPossessives: (str) ->
    str.replace('my', 'your')


module.exports  = new Responder()
