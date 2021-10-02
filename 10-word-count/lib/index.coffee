through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0

  transform = (chunk, encoding, cb) ->
    if chunk.includes('\n')
      allLines = chunk.split('\n')
      allLines.forEach (line) ->
        if line
          lines += 1
          if line.includes('"')
            handelQuotes(line)
          else
            handelCamelCase(line)
    else
      lines = 1
      if chunk.includes('"')
        handelQuotes(chunk)
      else
        handelCamelCase(chunk)
    return cb()

  # this function will handle the word count for a normal/camel cased word
  handelCamelCase = (chunk) ->
    wordsInLine = chunk.split(' ')
    wordsInLine.forEach (phrase) -> 
      if phrase
        words += phrase.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ').length

  # this function will make sure that characters inside quotes are considered as 1 word only
  handelQuotes = (chunk) ->
    regex = new RegExp('"(.*?)"','g')
    allQuotedPhrases = Array.from chunk.matchAll(regex), (m) ->
      m[1]
    wordsInLine = chunk.split(/["]/)
    wordsInLine.forEach (phrase) ->
      if phrase
        if allQuotedPhrases.includes(phrase)
          words += 1
        else
          phrase = phrase.trim()
          handelCamelCase(phrase)

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
