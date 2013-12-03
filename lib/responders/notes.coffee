class Responder extends Bitbot.BaseResponder

  responderName: "Notes"
  responderDesc: "Love a note for another user, I'll tell them next time they join."

  commandPrefix: "note"

  commands:
    create:
      desc: "Creates a note for someone"
      examples: ["tell Jay to do something.", "tell Jeremy to do something next time he's on.", "note to JZ, please do something."]
      intent: "notecreate"
      opts:
        user: {type: "string", entity: "contact"}
        reminder: {type: "string"}

    read:
      desc: "Read / clear all notes intended for you"
      examples: ["show me my notes.", "do I have any notes?", "read my notes."]
      intent: "noteread"

  templates:
    missingUser: "Sorry {{&name}}, I couldn't find anyone with that name."
    missingNote: "Sorry {{&name}}, you need to provide a note too."
    unknownUser: "Sorry {{&initials}}, I don't think I've ever met {{&userName}}."
    createNote: "Okay {{&name}}, I'll leave a note for {{&other.name}}.\n❓ What do you want the note to say?"
    create: "Okay {{&initials}}, leaving a note for {{&other.name}}: \"{{&note}}\""
    read: "Hey {{&initials}}, {{&from}} left you a note: {{&body}}"
    list: """
      📝 Notes for {{&name}}

      {{#message}}{{&.}}{{/message}}{{#notes}}From: {{&from}} ({{&datetime}}), \"{{&body}}\"\n{{/notes}}
      """


  respondToEvent: (event, user, callback) ->
    return unless event == 'enter'
    registry = new Registry(user.id)
    registry.all false, (record) =>
      return unless record
      message = @t('read', originalMessage: {user: user}, from: record.from, body: record.body)
      callback(speak: message, rooms: [record.room])


  create: (user, note) ->
    unless user then return speak: @t('missingUser')

    record = @users.find(user)
    unless record then return speak: @t('unknownUser', userName: user)

    # todo: the use of @message in this case is probably not a good idea -- I think there will be race conditions.
    if note
      registry = new Registry(record.id)
      registry.upsert @message.user.id,
        body: @processPossessives(note, @message.user.name)
        datetime: new Date()
        roomId: @message.room.id
        from: @message.user.fullName
      speak: @t('create', other: record, note: @processPossessives(note, @message.user.name))
    else
      speak: @t('createNote', other: record)
      prompt: (message) => @create(user, message.body)


  read: (callback) ->
    registry = new Registry(@message.user.id)
    registry.all true, (records) =>
      message = "Looks like you're all clear!" unless records
      notes = []
      for record in records || []
        registry.remove(record._token)
        notes.push
          from: record.from
          body: record.body
          datetime: @humanTime(record.datetime)
      callback(paste: @t('list', message: message, notes: notes))


  # private


  processPossessives: (str, fromUserName) ->
    return '' unless str
    str = str.replace(/(?:\b)he is|she is(?:\b)/gi, 'you are')
    str = str.replace(/(?:\b)he's|she's(?:\b)/gi, "you're")
    str = str.replace(/(?:\b)he|she(?:\b)/gi, 'you')
    str = str.replace(/(?:\b)his|her|him(?:\b)/gi, 'your')
    str = str.replace(/(?:\b)himself|herself(?:\b)/gi, 'yourself')
    str = str.replace(/(?:\b)my(?:\b)/gi, "#{fromUserName}'s")
    str = str.replace(/(?:\b)me(?:\b)/gi, fromUserName)
    str


class Registry extends Bitbot.BaseResponder.Registry
  constructor: (forUserId) -> super("notes-#{forUserId}")



module.exports  = new Responder()
