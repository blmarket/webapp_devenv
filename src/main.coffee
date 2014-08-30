console.log 'Hello World'

nv.addGraph ->
  converted = for it in data
    date = it.date
    tag_obj = {}
    for jt in it.tags
      tag_obj[jt.name] = jt.value
    { 
      x: new Date("#{date[0...4]}-#{date[4...6]}-#{date[6...8]}").getTime()
      y: -Number(tag_obj['clan_place'])
    }

  # converted = for i in [1..100]
  #   { x: i, y: Math.sin(i / 10) }

  console.log converted

  chart = nv.models.lineChart()

  chart.xAxis.axisLabel('Time (ms)').tickFormat((d) -> d3.time.format('%x')(new Date(d)));
  chart.yAxis.axisLabel('Voltage (v)').tickFormat((v) -> d3.format('.02f')(-v)) ;

  d3.select('#chart svg').datum([{ values: converted, key: 'Shaun', color: '#ff0000' }]).call(chart)

  nv.utils.windowResize(chart.update)

  chart
