#+--------------------------------------------------------------------+
#| for.coffee
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
Block = require('../block')
Template = require('../template')
Utils = require('./utils')

module.extends = class For extends Block

  tagSyntax: /(\w+)\s+in\s+((?:\(?[\w\-\.\[\]]\)?)+)/
  constructor: (tag, markup, tokens) ->
    matches = markup.match(@tagSyntax)
    if matches
      @variableName = matches[1]
      @collectionName = matches[2]
      @name = @variableName + "-" + @collectionName
      @attributes = {}
      attrmarkup = markup.replace(@tagSyntax, "")
      attMatchs = markup.match(/(\w*?)\s*\:\s*("[^"]+"|'[^']+'|[^\s,|]+)/g)
      if attMatchs
        attMatchs.forEach ((pair) ->
          pair = pair.split(":")
          @attributes[pair[0].trim()] = pair[1].trim()
        ), this
    else
      throw ("Syntax error in 'for loop' - Valid syntax: for [item] in [collection]")
    super tag, markup, tokens

  render: (context) ->
    output = []
    collection = (context.get(@collectionName) or [])
    range = [0, collection.length]
    context.registers["for"] = {}  unless context.registers["for"]
    if @attributes["limit"] or @attributes["offset"]
      offset = 0
      limit = 0
      rangeEnd = 0
      segment = null
      if @attributes["offset"] is "continue"
        offset = context.registers["for"][@name]
      else
        offset = context.get(@attributes["offset"]) or 0
      limit = context.get(@attributes["limit"])
      rangeEnd = (if (limit) then offset + limit + 1 else collection.length)
      range = [offset, rangeEnd - 1]

      # Save the range end in the registers so that future calls to
      # offset:continue have something to pick up
      context.registers["for"][@name] = rangeEnd

    # Assumes the collection is an array like object...
    segment = collection.slice(range[0], range[1])
    return ""  if not segment or segment.length is 0
    context.stack =>
      length = segment.length
      segment.forEach (item, index) =>
        context.set @variableName, item
        context.set "forloop",
          name: @name
          length: length
          index: (index + 1)
          index0: index
          rindex: (length - index)
          rindex0: (length - index - 1)
          first: (index is 0)
          last: (index is (length - 1))

        output.push (@renderAll(@nodelist, context) or []).join("")


    Utils.flatten([output]).join ""

Template.registerTag "for", For