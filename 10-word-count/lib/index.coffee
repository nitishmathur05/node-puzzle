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
            quotedPhrase = line.match(/"(.*?)"/)[1] # assuming there will be just one occurance of double quotes
            wordsInLine = line.split(/["]/)
            wordsInLine.forEach (phrase) ->
              if phrase
                if quotedPhrase == phrase
                  words += 1
                else
                  phrase = phrase.trim()
                  words += phrase.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ').length
          else
            wordsInLine = line.split(' ')
            wordsInLine.forEach (phrase) -> 
              words += phrase.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ').length
    else
      lines = 1
      if chunk.includes('"')
        quotedPhrase = chunk.match(/"(.*?)"/)[1] # assuming there will be just one occurance of double quotes
        wordsInLine = chunk.split(/["]/)
        wordsInLine.forEach (phrase) ->
          if phrase
            if quotedPhrase == phrase
              words += 1
            else
              phrase = phrase.trim()
              words += phrase.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ').length
      else
        tokens = chunk.split(' ')
        tokens.forEach (phrase) ->
          words += phrase.replace(/([a-z])([A-Z])/g, '$1 $2').split(' ').length
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
