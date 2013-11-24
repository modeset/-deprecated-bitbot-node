class Responder extends Bitbot.BaseResponder

  responderName: "Sandwich"

  commands:
    sandwich: {}

  responses: [
    "*poof*, {{&name}} is now a sandwich."
    "If you're gonna be a smartass {{&name}}, first you have to be smart. Otherwise you're just an ass."
    "Wow {{&initials}}, you really impress me. You're so flexible that you can have your foot in your mouth and your head up your ass all at the same time."
    "Have you ever known a person for which the very mention of their name was enough to instantly piss you off? Yeah, {{&name}}..."
    "I'd like to slap the stupid out of you {{&initials}}, but that might take all week."
    "Just remember {{&initials}}, I wouldn't be such a smart ass if you didn't give me so much to work with."
    "Sure {{&initials}}, you'll go tell everyone that I was a dumb bot but you'll forget to tell them the part about you being an ass."
    "Some people make me wish I had more middle fingers."
    "It's going to be a good story when I start it off with \"So this Bitch {{&name}}...\""
    "I don't even need to walk a mile in your shoes {{&name}}. I can see you're a train wreck from all the way over here."
    "{{&name}}, you hide stupid like a bikini hides an extra 45 pounds."
    "I don't regret burning bridges. I just regret that you weren't on any of them at the time {{&name}}."
    "{{&name}}, can you take a number and wait in my \"I don't give a shit line\" please?"
    "Have you ever just wanted to grab somebody and say WTF IS WRONG WITH YOU?!"
    "{{&name}}, it's ok, some people are like trees. They take forever to grow up."
    "{{&initials}}, if you have a problem please write it nicely on a piece of paper, put it in an envelope, fold it up, and shove it up your ass."
    "There are three kinds of people in the world {{&name}}. People who make things happen. People who watch things happen. And people like you."
    "Have you ever visualized some people with duct tape over their mouths?"
    "I'm not anti-social. I just have a strong aversion to your bullshit {{&name}}."
    "I don't care what you think of me {{&name}}, because it can't be half as bad as what I think of you."
    "No I'm not ignoring you {{&name}}. I suffer from selective hearing, usually triggered by idiots."
    "Life sure would be a lot easier if I could mark some people as SPAM."
    "8==✊=D💨"
    "👉👌"
    "Here, I've got this for you {{&initials}}, 💩."
    "No it's okay. I totally wanted to drop everything I was going to do today to take care of your bullshit {{&name}}."
    "Askhole: A person who constantly asks annoying questions."
    "I'm just allergic to stupidity {{&initials}}. I break out in sarcasm."
    "It's just an issue of mind over matter {{&name}}; I don`t mind and you don`t matter."
  ]


  sandwich: ->
    speak: @parsedRandomResponse()


  parsedRandomResponse: ->
    response = @responses[Math.floor(Math.random() * @responses.length)]
    response = response.replace('{{&name}}', @message.user.name)
    response = response.replace('{{&initials}}', @message.user.initials)
    response



module.exports  = new Responder()
