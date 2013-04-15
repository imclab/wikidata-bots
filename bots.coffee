# assumes jQuery and async are available

stats = {}

jQuery ->
  $ = jQuery
  $.getJSON("bots.json", getStats)

getStats = (bots) ->
  botNames = (name for name of bots)
  stats = async.map(botNames, getBotStats, drawChart)

getBotStats = (name, callback) ->
  url = "/stats/#{name}_hour.json"
  $.getJSON url, (stats) ->
    stats.shift() # pop off column headers
    stats.unshift(name) # push on the name for this stat
    callback(null, stats)

drawChart = (err, stats) ->
  ctx = $('#chart').get(0).getContext("2d")
  chart = new Chart(ctx)
  data = makeData(stats)
  console.log data
  opts =
    pointDot: false,
    datasetFill: false,
    scaleShowLabels: true,
    datasetStrokeWidth: 2
  chart.Line(data, opts)
  legend = $("#legend")
  for dataset in data.datasets
    li = $("<li>" + dataset.name + " " + dataset.strokeColor + "</li>")
    li.css(color: dataset.strokeColor)
    legend.append(li)

makeData = (stats) ->
  datasets = []
  for s, i in stats
    name = s.shift()
    labels = makeLabels(stats)
    data = []
    hasData = false
    for row in s
      if row[1] > 0
        hasData = true
      data.push(row[1])
    color = colors[i]
    if hasData
      datasets.push(name: name, strokeColor: color, data: data)
  return labels: labels, datasets: datasets

makeLabels = (stats) ->
  count = 0
  labels = []
  for row in stats[1]
    if count % 7 == 0
      d = new Date(row[0] * 1000)
      labels.push(formatDate(d))
    else
      labels.push("")
    count += 1
  return labels

pad = (n) ->
  if n < 10
    return '0' + n
  else
    return n

formatDate = (d) ->
  return d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate()) + ' '

rgba = ->
  r = parseInt(Math.random() * 255 + 1)
  g = parseInt(Math.random() * 255 + 1)
  b = parseInt(Math.random() * 255 + 1)
  x = "rgba(#{r}, #{g}, #{b}, 0.8)"
  console.log x
  return x

colors = [
    "blue",
    "blueviolet",
    "brown",
    "cadetblue",
    "chartreuse",
    "chocolate",
    "cornflowerblue",
    "crimson",
    "cyan",
    "darkblue",
    "darkcyan",
    "darkgoldenrod",
    "darkgray",
    "darkgreen",
    "darkkhaki",
    "darkmagenta",
    "darkolivegreen",
    "darkorange",
    "darkorchid",
    "darkred",
    "darksalmon",
    "darkseagreen",
    "darkturquoise",
    "darkviolet",
    "deeppink",
    "deepskyblue",
    "dimgray",
    "dodgerblue",
    "firebrick",
    "forestgreen",
    "fuchsia",
    "gainsboro",
    "ghostwhite",
    "gold",
    "goldenrod",
    "gray",
    "green",
    "greenyellow",
    "honeydew",
    "hotpink",
    "indianred",
    "indigo",
    "ivory",
    "khaki",
    "lavender",
    "lavenderblush",
    "lawngreen",
    "lemonchiffon",
    "lightblue",
    "lightcoral",
    "lightcyan",
    "lightgoldenrodyellow",
    "lightgreen",
    "lightpink",
    "lightsalmon",
    "lightseagreen",
    "lightskyblue",
    "lightslategray",
    "lightsteelblue",
    "lightyellow",
    "lime",
    "limegreen",
    "linen",
    "magenta",
    "maroon",
    "mediumaquamarine",
    "mediumblue",
    "mediumorchid",
    "mediumpurple",
    "mediumseagreen",
    "mediumslateblue",
    "mediumspringgreen",
    "mediumturquoise",
    "mediumvioletred",
    "midnightblue",
    "mintcream",
    "mistyrose",
    "moccasin",
    "navajowhite",
    "navy",
    "oldlace",
    "olive",
    "olivedrab",
    "orange",
    "orangered",
    "orchid",
    "palegoldenrod",
    "palegreen",
    "paleturquoise",
    "palevioletred",
    "papayawhip",
    "peachpuff",
    "peru",
    "pink",
    "plum",
    "powderblue",
    "purple",
    "red",
    "rosybrown",
    "royalblue",
    "saddlebrown",
    "salmon",
    "sandybrown",
    "seagreen",
    "seashell",
    "sienna",
    "silver",
    "skyblue",
    "slateblue",
    "slategray",
    "snow",
    "springgreen",
    "steelblue",
    "tan",
    "teal",
    "thistle",
    "tomato",
    "turquoise",
    "violet",
    "wheat",
    "whitesmoke",
    "yellow",
    "yellowgreen"
]
