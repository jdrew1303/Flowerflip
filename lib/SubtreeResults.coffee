class SubtreeResults
  constructor: (@tasks) ->
    @finished = false
    @branches = []
    @aborted = []
    @fulfilled = []
    @rejected = []

  countFulfilled: ->
    full = 0
    for f in @fulfilled
      continue unless f
      full += Object.keys(f).length
    full
  countRejected: ->
    rej = 0
    for r in @rejected
      continue unless r
      rej += Object.keys(r).length
    rej
  countAborted: ->
    aborted = @aborted.filter (a) -> not a.branched
    aborted.length
  isComplete: ->
    todo = @tasks + @branches.length - @aborted.length
    done = @countFulfilled() + @countRejected()
    @finished = done >= todo
    return @finished

  getFulfilled: -> @getResults @fulfilled
  getRejected: -> @getResults @rejected
  getResults: (collection) ->
    collection.map (f, i) ->
      return unless f
      keys = Object.keys f
      if keys.length is 1
        return collection[i][keys[0]].value
      keys.map (k) -> collection[i][k].value

  handleResult: (collection, idx, choice, value, callback) ->
    path = if choice then choice.toString() else ''
    collection[idx] = {} unless collection[idx]
    collection[idx][path] =
      choice: choice
      value: value
    callback @, value

  toJSON: ->
    state =
      tasks: @tasks
      finished: @finished
      branches: @branches.slice 0
      aborted: @aborted.slice 0
      fulfilled: @fulfilled.slice 0
      rejected: @rejected.slice 0
    state

module.exports = SubtreeResults