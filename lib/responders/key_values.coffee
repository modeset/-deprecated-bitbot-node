class Responder extends Bitbot.BaseResponder

  responderName: "Key / Value"
  responderDesc: "I'll store values in a key value type store so you can keep username, urls etc. for a room."

  commandPrefix: "data"

  commands:
    create:
      desc: "Stores a key / value pair"
      examples: ["store foo with bar.", "remember foo with bar.", "keep bar for foo on file.", "note foo, bar"]
      intent: "keyvaluecreate"
      opts:
        key: {type: "string", entity: "message_subject"}
        value: {type: "string", entity: "message_body"}

    remove:
      desc: "Removes a key / value"
      examples: ["remove the foo key/value.", "remove foo.", "remove the foo data."]
      intent: "keyvalueremove"
      opts:
        key: {type: "string", entity: "message_subject"}

    list:
      desc: "List the keys and values that are stored"
      examples: ["what data is stored?", "list stored data.", "list key/values.", "key values?"]
      intent: "keyvaluelist"

  templates:
    missingKeyValue: "Sorry {{&name}}, I didn't get what you wanted me to store. Try rephrasing the request."
    noted: "Okay {{&initials}}, I noted \"{{&key}}\" - \"{{&value}}\"."
    removed: "Okay {{&name}}, I removed the \"{{&key}}\" from my notes."
    list: """
      📝 Key / Value Data:

      {{#data}}{{&_token}} - {{&value}}\n{{/data}}
      """


  create: (key, value) ->
    unless key && value then return speak: @t('missingKeyValue')

    registry = new Registry(@message.room.id)
    registry.upsert(key, {value: value})

    speak: @t('noted', key: key, value: value)


  remove: (key) ->
    unless key then return speak: @t('missingKeyValue')

    registry = new Registry(@message.room.id)
    registry.remove(key)

    speak: @t('removed', key: key)


  list: (callback) ->
    registry = new Registry(@message.room.id)
    registry.all true, (records) =>
      callback(paste: @t('list', data: records))



class Registry extends Bitbot.BaseResponder.Registry
  constructor: (roomId) -> super("notes-#{roomId}")



module.exports = new Responder()
