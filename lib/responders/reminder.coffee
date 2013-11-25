class Responder extends Bitbot.BaseResponder

  responderName: "Reminders"
  responderDesc: "Tell me to remind you about something, and I'll keep track of it and remind you."

  commandPrefix: "reminder"

  intervals:
    remind: 20 * 1000

  commands:
    create:
      desc: "Creates a reminder for yourself"
      examples: ["remind me to call Janet on Friday at noon.", "create a reminder to deliver a package Tomorrow.", "add a reminder to do something next Monday at 2:30pm"]
      intent: "reminder" # todo: should be remindercreate when wit allows changing this
      opts:
        reminder: {type: "string"}
        datetime: {type: "string"}
        location: {type: "string"}

    list:
      desc: "Lists your upcoming reminders"
      examples: ["list my reminders.", "reminders?", "am I forgetting anything?", "what do I have going on?"]
      intent: "reminderlist"

    clear:
      desc: "Clears all of your reminders"
      examples: ["clear my reminders.", "remove all my reminders."]
      intent: "reminderclear"

  templates:
    missingReminder: "Sorry {{&name}}, you should provide something to remind you about."
    missingDatetime: "Sorry {{&initials}}, I got that you want to remember \"{{&reminder}}\", but you didn't provide a time to remind you."
    remind: "⏰ {{&name}}, {{&reminder}}{{#location}} (location: {{&.}}){{/location}}"
    createConfirm: "Okay {{&name}}, I'll remind you to \"{{&reminder}}\"{{#location}} (location: {{&.}}){{/location}}, on {{&datetime}}.\n❓ Do you want me to create it?"
    notCreated: "Okay {{&name}}, I didn't create it."
    created: "Okay {{&initials}}, I created the reminder for {{datetime}}."
    clear: "Okay {{&name}}, I've cleared all your reminders."
    list: """
      ⏰ Reminders for {{&fullName}}

      {{#message}}{{&.}}{{/message}}{{#reminders}}{{&clock}} {{datetime}} - \"{{reminder}}\"{{#location}} (location: {{&.}}){{/location}}\n{{/reminders}}
      """


  remind: (callback) ->
    Registry.matching "reminders-*-*", (record, key) =>
      if Moment(record.datetime).utc().subtract('minutes', 2).isBefore(Moment().utc())
        message = @t 'remind'
          originalMessage: record.message
          reminder: @processPossessives(record.reminder)
          location: @processPossessives(record.location)
        callback(speak: message, rooms: [record.message.room.id])
        new Registry(record.message.user.id).remove(key.match(/(\w+-\w+)/g)[1])


  create: (reminder, datetime, location) ->
    unless reminder then return speak: @t('missingReminder')
    unless datetime then return speak: @t('missingDatetime', reminder: reminder)

    speak: @t('createConfirm', reminder: reminder, datetime: @humanTime(datetime.from), location: location)
    confirm: (confirmed) =>
      unless confirmed then return speak: @t('notCreated')
      registry = new Registry(@message.user.id)
      token = Moment(datetime.from).format("X-[#{Math.floor(Math.random() * 100000)}]")
      registry.upsert(token, reminder: reminder, datetime: datetime.from, location: location, message: @message)
      speak: @t('created', datetime: @humanTime(datetime.from))


  list: (callback) ->
    registry = new Registry(@message.user.id)
    registry.all true, (records) =>
      message = "Looks like you're all clear!" unless records
      reminders = []
      for record in records || []
        reminders.push
          clock: @clockIcon(record.datetime)
          reminder: @processPossessives(record.reminder)
          datetime: @humanTime(record.datetime)
          location: @processPossessives(record.location)
      callback(paste: @t('list', message: message, reminders: reminders))


  clear: ->
    registry = new Registry(@message.user.id)
    registry.all(false, (record, token) -> registry.remove(token))
    speak: @t('clear')


  # private


  clockIcon: (time) ->
    time = Moment(time)
    clockIcons["i#{time.format('hh')}#{((((time.minutes() + 15) / 30 | 0) * 30) % 60) || '00'}"]


  displayableTime: (time, format = 'dddd, MMMM Do [at] h:mma') ->
    Moment(time).format(format)


  processPossessives: (str) ->
    return '' unless str
    str = str.replace(/(?:\b)my(?:\b)/, 'your')
    str = str.replace(/(?:\b)myself(?:\b)/, 'yourself')
    str = str.replace(/(?:\b)me(?:\b)/, 'you')
    str


  clockIcons =
    i0100: "🕐"
    i0130: "🕜"
    i0200: "🕑"
    i0230: "🕝"
    i0300: "🕒"
    i0330: "🕞"
    i0400: "🕓"
    i0430: "🕟"
    i0500: "🕔"
    i0530: "🕠"
    i0600: "🕕"
    i0630: "🕡"
    i0700: "🕖"
    i0730: "🕢"
    i0800: "🕗"
    i0830: "🕣"
    i0900: "🕘"
    i0930: "🕤"
    i1000: "🕙"
    i1030: "🕥"
    i1100: "🕚"
    i1130: "🕦"
    i1200: "🕛"
    i1230: "🕧"



class Registry extends Bitbot.BaseResponder.Registry
  constructor: (userId) -> super("reminders-#{userId}")



module.exports  = new Responder()
