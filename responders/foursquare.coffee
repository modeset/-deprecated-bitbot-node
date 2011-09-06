geo = require("geo")
foursquare = require("node-foursquare")({
  "secrets" : {
    "clientId":     "VHSYCVBSFG20NNSAMIHOAF2AXC5HXXK0EFLRTZS0RTFT21FB",
    "clientSecret": "SJZMIGADBMRAIEIMHV1I2TKZORDJLANSM5M2ILPHTBYMQGWV",
    "redirectUrl":  "http://bitbot.heroku.com/callback"
  }
})

exports.helpMessage = "find you nearby coffee/food/booze when you say 'find me <thing> near <location>'"

exports.receiveMessage = (message, room, client) ->
  msg_regex = /^find me (.+) near (.+)/
  if message.body and msg_regex.test( message.body )
    regex_results = msg_regex.exec(message.body)
    thing         = regex_results[1]
    location      = regex_results[2]

    geo.geocoder(geo.google, location, false, (address, latitude, longitude) ->
      if address
        opts =
          section:  thing
          limit:    50

        console.log(address, latitude, longitude, opts)
        foursquare.Venues.explore(latitude, longitude, opts, null, (error, data) ->
          console.log(data)
          if (data.groups[0].items.length > 0)
            randomIndex = Math.floor(Math.random()*data.groups[0].items.length)
            console.log(randomIndex)
            venue = data.groups[0].items[randomIndex].venue
            room.speak "Try #{venue.name} at #{venue.location.address}"
          else
            room.speak "Sorry, couldn't find any #{thing} near #{address}"
        )
      else
        room.speak "Sorry, couldn't find any #{thing} near #{location}"
    )