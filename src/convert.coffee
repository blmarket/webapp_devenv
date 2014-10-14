lR = require 'line-reader'

arr = []

lR.eachLine(
  'logs'
  (line, last, cb) ->
    arr.push JSON.parse(line)
    cb()
    return
).then ->
  console.log JSON.stringify(arr)
  return
