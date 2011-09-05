geo = require("geo")
foursquare = require("node-foursquare")({
  "secrets" : {
    "clientId":     "VHSYCVBSFG20NNSAMIHOAF2AXC5HXXK0EFLRTZS0RTFT21FB",
    "clientSecret": "SJZMIGADBMRAIEIMHV1I2TKZORDJLANSM5M2ILPHTBYMQGWV"
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
      opts =
        section:  thing
        limit:    1
      console.log(address, latitude, longitude, opts)
      foursquare.Venues.explore(latitude, longitude, opts, null, (error, data) ->
        console.log(data)
        venue = data.groups[0].items[0].venue
        room.speak "Try #{venue.name} at #{venue.address}"
      )
    )