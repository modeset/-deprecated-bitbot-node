request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Fortune"
  responderDesc: "Provides a fortune when asked for one."

  commandPrefix: "fortune"

  commands:
    cookie:
      desc: "Generates a fortune"
      examples: ["fortune me.", "what's my fortune?", "give me a fortune cookie."]
      intent: "fortunecookie"

  templates:
    cookie: "🔮 {{&initials}}, {{&response}}{{#sultry}}.. In bed.{{/sultry}}"

  responses: [
    "conquer your fears or they will conquer you."
    "you only need look to your own reflection for inspiration."
    "rivers need springs."
    "good news from afar may bring you a welcome visitor."
    "when all else seems to fail, smile for today and just love someone."
    "when you look down, all you see is dirt, so keep looking up."
    "if you are afraid to shake the dice, you will never throw a six."
    "a single conversation with a wise man is better than ten years of study."
    "happiness is often a rebound from hard work."
    "the world may be your oyster, but that doesn't mean you'll get it's pearl."
    "you're true love will show himself to you under the moonlight (no homo)."
    "do not follow where the path may lead. Go where there is no path...and leave a trail."
    "do not fear what you don't know."
    "the object of your desire comes closer."
    "if you wish to know the mind of a man, listen to his words."
    "the most useless energy is trying to change what and who you are."
    "do not be covered in sadness or be fooled in happiness they both must exist."
    "you will have unexpected good luck."
    "you will have a pleasant surprise."
    "all progress occurs because people dare to be different."
    "your ability for accomplishment will be followed by success."
    "we can't help everyone. But everyone can help someone."
    "you have a deep appreciation of the arts and music."
    "human evolution: 'wider freeway' but narrower viewpoints."
    "intelligence is the door to freedom and alert attention is the mother of intelligence."
    "back away from individuals who are impulsive."
    "a big fortune will descend upon you this year."
    "now these three remain, faith, hope, and love. The greatest of these is love."
    "for success today look first to yourself."
    "determination is the wake-up call to the human will."
    "there are no limitations to the mind except those we aknowledge."
    "a merry heart does good like a medicine."
    "whenever possible, keep it simple."
    "your dearest wish will come true."
    "poverty is no disgrace, unless you're a republican."
    "if you don’t do it excellently, don’t do it at all."
    "you have an unusual equipment for success, use it properly."
    "emotion is energy in motion."
    "you will soon be honored by someone you respect."
    "your happiness is intertwined with your outlook on life."
    "elegant surroundings will soon be yours."
    "if you feel you are right, stand firmly by your convictions."
    "your smile brings happiness to everyone you meet."
    "instead of worrying and agonizing, move ahead constructively."
    "endurance and persistence will be rewarded."
    "a new business venture is on the horizon."
    "never underestimate the power of the human touch (no homo)."
    "truth is an unpopular subject. Because it is unquestionably correct."
    "the most important thing in communication is to hear what isn’t being said."
    "you are broad minded and socially active."
    "your dearest dream is coming true."
    "you will recieve some high prize or award."
    "your present question marks are going to succeed."
    "you have a fine capacity for the enjoyment of life."
    "you will live long and enjoy life."
    "an admirer is concealing their affection for you."
    "a wish is what makes life happen when you dream of rose petals."
    "love can turn a cottage into a golden palace."
    "lend your money and lose your freind."
    "you will be rewarded for being a good listener in the next week."
    "if you never give up on love, It will never give up on you."
    "your wish will come true."
    "there is a prospect of a thrilling time ahead for you."
    "no distance is too far, if two hearts are tied together."
    "land is always in the mind of the flying birds."
    "try? No! Do or do not, there is no try."
    "do not worry, you will have great peace."
    "you create your own stage ... the audience is waiting."
    "it is never too late. Just as it is never too early."
    "discover the power within yourself."
    "good things take time."
    "stop thinking about the road not taken and pave over the one you did."
    "put your unhappiness aside. Life is beautiful, be happy."
    "you can still love what you can not have in life."
    "make a wise choice everyday."
    "circumstance does not make the man; it reveals him to himself."
    "the man who waits till tomorrow, misses the opportunities of today."
    "life does not get better by chance. It gets better by change."
    "if you never expect anything you can never be disappointed."
    "people in your surroundings will be more cooperative than usual."
    "true wisdom is found in happiness."
    "ones always regrets what could have done. Remember for next time."
    "follow your bliss and the Universe will open doors where there were once only walls."
    "find a peaceful place where you can make plans for the future."
    "all the water in the world can't sink a ship unless it gets inside."
    "the earth is a school learn in it."
    "in music, one must think with his heart and feel with his brain."
    "if you speak honestly, everyone will listen."
    "ganerosity will repay itself sooner than you imagine."
    "good things take time."
    "do what is right, not what you should."
    "to effect the quality of the day is no small achievement."
    "simplicity and clarity should be the theme in your dress."
    "not all closed eye is sleeping, nor open eye is seeing."
    "bread today is better than cake tomorrow."
    "a feeling is an idea with roots."
    "man is born to live and not prepared to live."
    "it's all right to have butterflies in your stomach. Just get them to fly in formation."
    "if you don t give something, you will not get anything."
    "you will think for yourself when you stop letting others think for you."
    "time will prove you right, you must stay where you are."
    "let's finish this up now, someone is waiting for you on that."
    "the finest men like the finest steels have been tempered in the hottest furnace."
    "a dream you have will come true."
    "i think you ate your fortune while you were eating your cookie."
    "the cooler you think you are the dumber you look."
    "expect great things and great things will come."
    "the Wheel of Good Fortune is finally turning in your direction."
    "don't lead if you won't lead."
    "you will always be successful in your professional career."
    "share your happiness with others today."
    "it's up to you to clarify."
    "your future will be happy and productive."
    "seize every second of your life and savor it."
    "those who walk in other's tracks leave no footprints."
    "failure is the mother of all success."
    "difficulty at the beginning usually means ease at the end."
    "do not seek so much to find the answer as much as to understand the question better."
    "your way of doing what other people do their way is what makes you special."
    "a beautiful, smart, and loving person will be coming into your life."
    "friendship is an ocean that you cannot see the bottom of."
    "your life does not get better by chance, it gets better by change."
    "our duty, as men and women, is to proceed as if limits to our ability did not exist."
    "a pleasant expeience is ahead; don't pass it by."
    "our perception and attitude toward any situation will determine the outcome."
    "they say you are stubborn; you call it persistence."
    "two small jumps are sometimes better than one big leap."
    "a new wardrobe brings great joy and change to your life."
    "the cure for grief is motion."
    "it's a good thing that life is not as serious as it seems to the waiter."
    "ideas you believe are absurd ultimately lead to success."
    "a human being is a deciding being."
    "today is an ideal time to water your parsonal garden."
    "some men dream of fortunes, others dream of cookies."
    "things are never quite the way they seem."
    "the project on your mind will soon gain momentum."
    "in order to get the rainbow, you must first endure the rain."
    "beauty is simply beauty. originality is magical."
    "your dream will come true when you least expect it."
    "let not your hand be stretched out to receive and shut when you should repay."
    "don't worry, half the people you know are below average."
    "vision is the art of seeing what is invisible to others."
    "you don't need talent to gain experience."
    "a focused mind is one of the most powerful forces in the universe."
    "today you shed your last tear. Tomorrow fortune knocks at your door."
    "be patient! The Great Wall didn't got build in one day."
    "think you can. Think you can't. Either way, you'll be right."
    "wisdom is on her way to you."
    "digital circuits are made from analog parts."
    "if you eat a box of fortune cookies, anything is possible."
    "the best is yet to come."
    "i'm with you."
    "be direct,usually one can accomplish more that way."
    "a single kind work will keep one warm for years."
    "ask a friend to join you on your next voyage."
    "love is free. Lust will cost you everything you have."
    "stop searching forever, happiness is just next to you."
    "you don't need the answers to all of life's questions. Just ask Jeremy what to do."
    "jealousy is a useless emotion."
    "you are not a ghost."
    "there is someone rather annoying in your life that you need to listen to."
    "you will plant the smallest seed and it will become the greatest and most mighty tree in the world."
    "see if you can learn anything from the children."
    "it's never too late for good things to happen."
    "a clear conscience is usually the sign of a bad memory."
    "aim high, time flies."
    "one who is not sleeping, does not mean they are awake."
    "a great pleasure in life is doing what others say you can't."
    "isn't there something else you should be working on right now."
    "before you can be reborn you must die."
    "it's better to be the hammer than the nail."
    "you are admired by everyone for your talent and ability."
    "you will soon discover a major truth about the one you love most."
    "your life will prosper only if you acknowledge your faults and work to reduce them."
    "pray, but row towards shore."
    "trust, but verify."
    "you will soon witness a miracle."
    "the early bird gets the worm, but the second mouse gets the cheese."
    "you are a persoon with a good sense of justice, now it's time to act like it."
    "you create enthusiasm around you."
    "there are big changes ahead for you. They will be good ones."
    "you will have many happy days soon."
    "out of confusion comes new patterns."
    "live like you are on the bottom, even if you are on the top."
    "you will soon emerge victorious from the maze you've been traveling in."
    "do not judge a book by it's cover."
    "everything will come your way."
    "there is a time to be practical now."
    "bend the rod while it is still hot."
    "darkness is only succesful when there is no light."
    "acting is not lying. It is findind someone hiding inside you and letting that person run free."
    "you will be forced to face fear, but if you do not run, fear will be afraid of you."
    "you are thinking about doing something. Don't do it, it won't help anything."
    "bad luck and misfortune will follow you all your days."
    "be a good friend and a fair enemy."
    "what goes around comes around."
    "the best prophet of the future is the past."
    "movies have pause buttons, friends do not."
    "use the force."
    "trust your intuition."
    "encourage your peers."
    "let your imagination wander."
    "your pain is the breaking of the shell that encloses your understanding."
    "patience is key, a wait short or long will have its reward."
    "a bird in the hand is worth three in the bush."
    "be assertive when decisive action is needed."
    "to determine whether someone is beautiful is not by looking at their appearance, but their heart."
    "傷心有多少 在乎就有多."
    "hope brings about a better future."
    "even though it will often be difficult and complicated, you know you have what it takes to get it done."
    "you will prosper in the field of wacky inventions."
    "your tongue is your ambassador."
    "the cure for grief is movement."
    "you are often asked if it is in yet."
    "life to you is a bold and dashing responsibility."
    "patience is a key to joy."
    "a bargain is something you don't need at a price you can't resist."
    "today is going to be a disasterous day, be prepared."
    "stay to your inner-self, you will benefit in many ways."
    "rarely do great beauty and great virtue dwell together as they do in you."
    "you are talented in many ways."
    "you are the master of every situation."
    "your problem just got bigger. Think, what have you done."
    "go with the flow, it will make your transition ever so much easier."
    "a metaphor could save your life."
    "don't wait for your ship to come in, swim out to it."
    "there are lessons to be learned by listening to others."
    "it takes more than a good memory to have good memories."
    "you are what you are; understand yourself before you react."
    "word to the wise: Don't play leapfrog with a unicorn."
    "forgive your enemies, but never forget them."
    "everything will now come your way."
    "don't worry about the stock market. Invest in family."
    "your fortune is as sweet as a cookie."
    "it is much easier to look for the bad, than it is to find the good."
    "you are worth loving, you are also worth the effort it takes to love you."
    "never trouble trouble till trouble troubles you."
    "get off to a new start - come out of your shell."
    "minor aches today are likely to pay off handsomely tomorrow."
    "your mouth may be moving, but nobody is listening."
    "the problem with resisting temptation is that it may never come again."
    "all your sorrows will vanish."
    "love will lead the way."
    "the ads revenge is massive success."
    "it is best to act with confidence, no matter how little right you have to it."
    "soon, a visitor shall delight you."
    "what breaks in a moment may take years to mend."
  ]


  cookie: ->
    speak: @t('cookie', response: @random(), sultry: Math.floor(Math.random() * 10) + 1 < 3)



module.exports  = new Responder()
