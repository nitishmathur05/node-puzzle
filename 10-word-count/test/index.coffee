assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words and numbers in a phrase', (done) ->
    input = 'this is a basic test 101'
    expected = words: 6, lines: 1
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

describe 'test-file-fixtures', ->
  it 'should read a simple line in a file', (done) ->
    fs.readFile "#{__dirname}/fixtures/1,9,44.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data
      expected = words: 9, lines: 1
      helper input, expected, done

  it 'should read a multiple lines in a file and simple words', (done) ->
    fs.readFile "#{__dirname}/fixtures/9,9,44.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data
      expected = words: 9, lines: 9
      helper input, expected, done

  it 'should read multiple lines in a file and words with camel case', (done) ->
    fs.readFile "#{__dirname}/fixtures/5,9,40.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data
      expected = words: 9, lines: 5
      helper input, expected, done

  it 'should read multiple lines in a file and words with quotes', (done) ->
    fs.readFile "#{__dirname}/fixtures/3,7,46.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data
      expected = words: 7, lines: 3
      helper input, expected, done

  it 'should read multiple lines in a file and words with quotes occuring more than once', (done) ->
    fs.readFile "#{__dirname}/fixtures/3,5,50.txt", 'utf8', (err, data) ->
      if err then return cb err
      input = data
      expected = words: 5, lines: 3
      helper input, expected, done