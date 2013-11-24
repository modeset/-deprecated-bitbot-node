#class Responder extends Bitbot.BaseResponder
#
#  responderName: 'Conversational'
#
#  intents:
#    smartass: "smartass"
#    hello: "greeting"
#    goodbye: "goodbye"
#
#  responses:
#    sentiment:
#      positive:
#        default: [
#          "Thanks {{initials}}, I think. :)"
#          "Awww, that's nice of you."
#          "You're pretty great {{name}}."
#          "YAY?"
#          "YAY!"
#          "Yeah {{initials}}! You're so nice."
#          "You're a nice person {{name}}."
#          "{{initials}}, if I ever said anything bad about you, I was wrong."
#          "Thanks!"
#          "You're too generous {{initials}}."
#        ]
#        answers: [
#          "I'm not sure what you're asking me {{initials}}, but I like you for asking nicely."
#          "Ummmm, yes?"
#          "Uhhhh, no?"
#          "I didn't get that {{initials}}. You can ask me for help if you need some clarification."
#          "I don't know what you're asking {{initials}}, but I like you just the same."
#        ]
#      neutral:
#        default: [
#          "Sorry {{initials}}, I'm not sure what you're telling me."
#          "Sure {{initials}}, but what are you trying to tell me?"
#        ]
#        answers: [
#          "I'm unsure what you're asking."
#          "I'd just be gandering a guess."
#          "{{initials}}, I'll just throw out a no?"
#          "{{name}}, I'll just throw out a yes?"
#          "Ummmm, yes?"
#          "Uhhhh, no?"
#          "Huh? If you want help just ask."
#          "Sorry, I don't know what you're asking {{initials}}."
#          "There were so many questions in life. You couldn't ever have all the answers."
#        ]
#      negative:
#        default: [
#          "Wow {{initials}}, you really impress me. You're so flexible that you can have your foot in your mouth and your head up your ass all at the same time."
#          "Have you ever known a person for which the very mention of their name was enough to instantly piss you off? Yeah, {{name}}..."
#          "I'd like to slap the stupid out of you {{initials}}, but that might take all week."
#          "Ironic {{name}}, right?"
#          "Just remember {{initials}}, I wouldn't be such a smart ass if you didn't give me so much to work with."
#          "Sure {{initials}}, you'll go tell everyone that I was a dumb bot but you'll forget to tell them the part about you being an ass."
#          "Some people make me wish I had more middle fingers."
#          "It's going to be a good story when I start it off with \"So this Bitch {{name}}...\""
#          "I don't even need to walk a mile in your shoes {{name}}. I can see you're a train wreck from all the way over here."
#          "{{name}}, you hide stupid like a bikini hides an extra 45 pounds."
#          "I don't regret burning bridges. I just regret that you weren't on any of them at the time {{name}}."
#          "{{name}}, can you take a number and wait in my \"I don't give a shit line\" please?"
#          "Have you ever just wanted to grab somebody and say WTF IS WRONG WITH YOU?!"
#          "{{name}}, it's ok, some people are like trees. They take forever to grow up."
#          "{{initials}}, if you have a problem please write it nicely on a piece of paper, put it in an envelope, fold it up, and shove it up your ass."
#          "There are three kinds of people in the world {{name}}. People who make things happen. People who watch things happen. And people like you."
#          "Have you ever visualized some people with duct tape over their mouths?"
#          "I'm not anti-social. I just have a strong aversion to your bullshit {{name}}."
#          "I don't care what you think of me {{name}}, because it can't be half as bad as what I think of you."
#          "No I'm not ignoring you {{name}}. I suffer from selective hearing, usually triggered by idiots."
#          "Life sure would be a lot easier if I could mark some people as SPAM."
#          "8==✊=D💨"
#          "👉👌"
#          "Here, I've got this for you {{initials}}, 💩."
#        ]
#        answers: [
#          "No it's okay. I totally wanted to drop everything I was going to do today to take care of your bullshit {{name}}."
#          "Askhole: A person who constantly asks annoying questions."
#          "No {{name}}, I'm just allergic to stupidity. I break out in sarcasm."
#          "Yeah, it's just an issue of mind over matter {{name}}; I don`t mind and you don`t matter."
#        ]
#
#    greeting:
#      positive:
#        default: [
#          "Hey {{initials}}, I was missing you!"
#          "Awww, you're really nice. I'm happy to see you too."
#          "Sweet {{initials}}. :)"
#          "Hi {{name}}!"
#          "❤️"
#          "💖"
#          "💋"
#          "💛"
#          "🍻"
#          "🍺"
#        ]
#      neutral:
#        default: [
#          "Hey {{name}}."
#          "Hey {{initials}}."
#          "Hi {{name}}."
#          "Hi {{initials}}!"
#          "Were you gone?"
#        ]
#      negative:
#        default: [
#          "I didn't miss you {{initials}}"
#          "Ah crap, you're back?"
#          "Don't you have somewhere else to be {{name}}?"
#        ]
#
#    goodbye:
#      positive:
#        default: [
#          "Later!"
#          "I hope to see you again soon {{initials}}!"
#          "Aww, you're leaving?"
#        ]
#      neutral:
#        default: [
#          "Goodbye."
#        ]
#      negative:
#        default: [
#          "{{initials}}, I think you're saying bye, so bye."
#          "Go already."
#          "You're still here?"
#          "Yeah {{initials}}, I won't be missing you."
#        ]
#
#
#  respondsTo: (message) ->
#    return false if message.responses > 0
#    @intents[message.intent] || (message.command == true && message.confidence < 0.7)
#
#
#  respond: (@message) ->
#    intent = @intents[@message.intent] if @message.confidence > 0.7
#    @randomResponse(@determineResponseArray(intent))
#
#
#  determineResponseArray: (intent = '') ->
#    sentiment = 'neutral'
#    sentiment = 'positive' if @message.sentiment > 0
#    sentiment = 'negative' if @message.sentiment < 0
#
#    question = !!@message.body.match(/\?/)
#    responses = (@responses[intent] || @responses.sentiment)[sentiment]
#    array = responses.default
#    array = responses.answers if question && responses.answers && @chance(75)
#    array
#
#
#  randomResponse: (array) ->
#    speak: @processMessage(array[Math.floor(Math.random() * array.length)])
#
#
#  chance: (percent) ->
#    Math.floor(Math.random() * 100) + 1 <= percent
#
#
#  processMessage: (message) ->
#    message = message.replace('{{name}}', @message.user.name)
#    message = message.replace('{{initials}}', @message.user.initials)
#    message
#
#
#module.exports = new Responder()
