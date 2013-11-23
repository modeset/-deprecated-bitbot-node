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

    clear:
      desc: "Clears all of your reminders"

  clockMap:
    '0100': "🕐"
    '0130': "🕜"
    '0200': "🕑"
    '0230': "🕝"
    '0300': "🕒"
    '0330': "🕞"
    '0400': "🕓"
    '0430': "🕟"
    '0500': "🕔"
    '0530': "🕠"
    '0600': "🕕"
    '0630': "🕡"
    '0700': "🕖"
    '0730': "🕢"
    '0800': "🕗"
    '0830': "🕣"
    '0900': "🕘"
    '0930': "🕤"
    '1000': "🕙"
    '1030': "🕥"
    '1100': "🕚"
    '1130': "🕦"
    '1200': "🕛"
    '1230': "🕧"

  remind: (callback) =>
    redis.keys "reminder-*", (err, keys = []) =>
      for key in keys
        redis.get key, (err, str) ->
          obj = JSON.parse(str)
          if Moment(obj.time).utc().subtract('minutes', 2).isBefore(Moment().utc())
            message = "⏰ #{obj.userName}, here's your reminder: #{obj.reminder}"
            message += " (location: #{obj.location})" if obj.location
            callback(roomId: obj.roomId, speak: message)
            redis.del(key)

  create: (reminder, datetime, location) ->
    return {speak: "Sorry #{@message.user.name}, you need to provide something to remind you about."} unless reminder
    return {speak: "Sorry #{@message.user.initials}, I got that want a reminder to \"#{reminder}\", but you didn't provide a time."} unless datetime
    reminder = @processPossessives(reminder)
    time = datetime.from

    try
      msg = "I'll remind you to \"#{reminder}\", on #{@displayableTime(time)}."
      msg += " Location: #{location}." if location && location = @processPossessives(location)

      speak: "Ok #{@message.user.name}, #{msg}\n❓ Do you want me to create it?"
      confirm: (confirmed, message) =>
        return {speak: "Ok #{message.user.name}, I didn't create it."} unless confirmed
        @storeReminder(time, reminder, location, message)
        speak: "Ok #{message.user.initials}, I created the reminder for #{@displayableTime(time, "MMM Do [at] h:mma")}."
    catch e
      @log(e, 'error')
      speak: "Sorry #{message.user.initials}, but something went wrong."


  list: (callback) ->
    response = "⏰ Reminders for #{@message.user.name}\n"

    redis.keys "reminder-#{@message.user.id}-*", (err, keys = []) =>
      count = keys.length

      if count == 0 || err
        callback(speak: "#{response}Looks like you're all clear!")
        return

      for key in keys
        redis.get key, (err, str) =>
          obj = JSON.parse(str)
          response += "#{@clockDisplay(obj.time)} \"#{obj.reminder}\" is scheduled for #{@displayableTime(obj.time)}."
          response += " Location: #{obj.location}." if obj.location
          response += "\n"
          count -= 1
          callback(speak: response.replace(/\n+$/, '')) if count == 0


  clear: (callback) ->
    callback(speak: "#{@message.user.name}, I've cleared all your reminders.")
    redis.keys "reminder-#{@message.user.id}-*", (err, keys = []) =>
      redis.del(key, true) for key in keys


  storeReminder: (time, reminder, location, message) ->
    key = "reminder-#{message.user.id}-#{Moment(time).format('X')}"
    value = JSON.stringify(time: time, reminder: reminder, location: location, userName: message.user.name, roomId: message.room.id)
    redis.set(key, value)


  clockDisplay: (time) ->
    time = Moment(time)
    name = "#{time.format('hh')}#{((((time.minutes() + 15) / 30 | 0) * 30) % 60) || '00'}"
    @clockMap[name]


  displayableTime: (time, format = 'dddd, MMMM Do [at] h:mma') ->
    Moment(time).format(format);


  processPossessives: (str) ->
    str.replace('my', 'your')


module.exports  = new Responder()
