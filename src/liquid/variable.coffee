#+--------------------------------------------------------------------+
#| variable.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of liquid.coffee
#|
#| liquid.coffee is free software; you can copy, modify, and distribute
#| it under the terms of the GNU General Public License Version 3
#|
#+--------------------------------------------------------------------+
#
# Liquid Templates
#
Utils = require('./utils')

module.exports = class Variable

  constructor: (markup) ->
    @markup = markup
    @name = null
    @filters = []
    self = this
    match = markup.match(/\s*("[^"]+"|'[^']+'|[^\s,|]+)/)
    if match
      @name = match[1]
      filterMatches = markup.match(/\|\s*(.*)/)
      if filterMatches
        filters = filterMatches[1].split(/\|/)
        filters.forEach (f) ->
          matches = f.match(/\s*(\w+)/)
          if matches
            filterName = matches[1]
            filterArgs = []
            Utils.flatten(f.match(/(?:[:|,]\s*)("[^"]+"|'[^']+'|[^\s,|]+)/g) or []).forEach (arg) ->
              cleanupMatch = arg.match(/^[\s|:|,]*(.*?)[\s]*$/)
              filterArgs.push cleanupMatch[1]  if cleanupMatch

            self.filters.push [filterName, filterArgs]


  render: (context) ->
    return ""  unless @name?
    output = context.get(@name)
    @filters.forEach (filter) ->
      filterName = filter[0]
      filterArgs = (filter[1] or []).map((arg) ->
        context.get arg
      )
      filterArgs.unshift output # Push in input value into the first argument spot...
      output = context.invoke(filterName, filterArgs)

    output

