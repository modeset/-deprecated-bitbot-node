class Responder extends Bitbot.BaseResponder

  responderName: "News"
  responderDesc: "Provides news articles from various sources."

  commandPrefix: "news"

  commands:
    articles:
      desc: "Displays top news stories"
      examples: ["top 10 news stories.", "what's in the news?", "top 5 NHL articles.", "world news."]
      intent: "newstop"
      opts:
        count: {type: "integer", default: 3, entity: "number"}
        topic: {type: "string"}

    topics:
      desc: "Displays all news topics defined"
      examples: ["news topics.", "what sort of news do you have?"]
      intent: "newstopics"

  templates:
    unknownTopic: "Sorry {{&initials}}, I don't have a source for the topic you asked for, but here's the top news anyway."
    badService: "Sorry {{&name}}, but the news service doesn't seem to be working."
    articles: """
      📰 Top {{&count}} Stories from {{&source}}

      {{#articles}}
      ☛ {{&title}}\n   {{&link}}
      {{/articles}}
      """
    topics: """
      📰 Available News Topics

      Hey {{&name}}, here are the sources and topics that I can provide articles for.

      {{#sources}}
      {{&source}} - {{&url}}\n{{#topics}}  {{&source}} - {{&url}}\n{{/topics}}
      {{/sources}}
      """


  articles: (count, topic, callback) ->
    topic = @determineTopic(count, topic)

    callback(speak: @t('unknownTopic')) unless topic.found

    request topic.url, (err, response, body) =>
      try articles = JSON.parse(body)['responseData']['feed']['entries']
      catch e
        return callback(speak: @t('badService'))

      articles ||= []
      articles.splice(parseInt(count, 10))
      callback(paste: @t('articles', count: articles.length, source: topic.source, articles: articles))


  topics: ->
    # todo: does underscore have anything nice for this?
    sources = (value for name, value of _(feedSources).extend({}))
    for source in sources
      source.topics = (value for name, value of _(source.topics || []).extend({}))

    paste: @t('topics', sources: sources)


  # private


  determineTopic: (count, topic = 'default') ->
    base = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=#{count + 1}&q="
    topic = topic.toLowerCase()
    foundTopic = false
    for sourceName, sourceInfo of feedSources
      if topic == sourceName
        foundTopic = sourceInfo
        break
      if sourceInfo.topics
        for topicName, topicInfo of sourceInfo.topics
          if topic == topicName || topic == "#{sourceName} #{topicName}"
            foundTopic = topicInfo
            break

    if foundTopic
      found = true
    else
      foundTopic = feedSources['default']
      found = false

    found: found
    source: foundTopic.source
    url: "#{base}#{foundTopic.url}"


  feedSources =
    default:
      source: "New York Times"
      url: "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"

    salon:
      source: "Salon"
      url: "http://www.salon.com/feed/rss"

    science:
      source: "Scientific American"
      url: "http://rss.sciam.com/ScientificAmerican-Global?format=xml"

    slashdot:
      source: "Slashdot"
      url: "http://rss.slashdot.org/Slashdot/slashdot"

    hacker:
      source: "Hacker News"
      url: "https://news.ycombinator.com/rss"

    ruby:
      source: "Ruby Inside"
      url: "http://feeds.feedburner.com/RubyInside"

    tech:
      source: "CNET"
      url: "http://feeds.feedburner.com/cnet/NnTv"

    bbc:
      source: "BBC"
      url: "http://feeds.bbci.co.uk/news/rss.xml"
      topics:
        science:
          source: "BBC - Science"
          url: "http://www.bbc.co.uk/science/0/rss.xml"

    espn:
      source: "ESPN"
      url: "http://sports.espn.go.com/espn/rss/news"
      topics:
        nhl:
          source: "ESPN - NHL"
          url: "http://sports.espn.go.com/espn/rss/nhl/news"
        nfl:
          source: "ESPN - NFL"
          url: "http://sports.espn.go.com/espn/rss/nfl/news"
        nba:
          source: "ESPN - NBA"
          url: "http://sports.espn.go.com/espn/rss/nba/news"
        nba:
          source: "ESPN - MLB"
          url: "http://sports.espn.go.com/espn/rss/mlb/news"
        golf:
          source: "ESPN - Golf"
          url: "http://sports.espn.go.com/espn/rss/golf/news"
        tennis:
          source: "ESPN - Tennis"
          url: "http://sports.espn.go.com/espn/rss/tennis/news"



module.exports = new Responder()
