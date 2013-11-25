class Responder extends Bitbot.BaseResponder

  responderName: "Users"
  responderDesc: "I can look for users, and other things like that."

  commandPrefix: "user"

  commands:
    seen:
      desc: "Says when the user was last seen"
      examples: ["when was Jay on last?", "last time you saw Jeremy?"]
      intent: "userseen"
      opts:
        user: {type: "string"}

  templates:
    missingUser: "Sorry {{&name}}, I couldn't find anyone with no name."
    unknownUser: "Sorry {{&initials}}, I don't think I've ever met {{&userName}}."
    seenSaying: "Yeah {{&name}}, I saw {{&other.initials}} saying \"{{&message}}\" {{&timeAgo}} ago."
    seenIn: "Yeah {{&initials}}, I saw them in {{&roomName}} {{&timeAgo}} ago.."
    seenLeaving: "Yup {{&initials}}, but they left{{&roomName}} {{&timeAgo}} ago."
    seenJoining: "Yes {{&name}}, they joined{{&roomName}} {{&timeAgo}} ago."
    seenNever: "No {{&initials}}, I haven't seen them since I started paying attention (restarted)."


  respondToEvent: (event, user) ->
    user.joinedAt = new Date() if event == 'enter'
    user.leftAt = new Date() if event == 'leave'


  seen: (user) ->
    unless user then return speak: @t('missingUser')

    record = @users.find(user)
    unless record then return speak: @t('unknownUser', userName: user)

    if record.lastMessage
      timeAgo = @timeAgo(record.lastMessage.sentAt)
      roomName = record.lastMessage.roomName || 'another room'
      if roomName == @message.room.name
        speak: @t('seenSaying', other: record, message: record.lastMessage.body, timeAgo: timeAgo)
      else
        speak: @t('seenIn', other: record, roomName: roomName, timeAgo: timeAgo)
    else
      roomName = " #{record.lastMessage.roomName || 'another room'}" if record.lastMessage
      if record.leftAt
        speak: @t('seenLeaving', other: record, roomName: roomName, timeAgo: @timeAgo(record.leftAt))
      else if record.joinedAt
        speak: @t('seenJoining', other: record, roomName: roomName, timeAgo: @timeAgo(record.joinedAt))
      else
        speak: @t('seenNever', other: record)


  # private


  timeAgo: (time) ->
    Moment(time).fromNow(true)



module.exports = new Responder()
