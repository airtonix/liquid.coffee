#+--------------------------------------------------------------------+
#| assign.coffee
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
Liquid = require('../../liquid')

class Liquid.Tags.Assign extends Liquid.Tag

  tagSyntax: /((?:\(?[\w\-\.\[\]]\)?)+)\s*=\s*((?:"[^"]+"|'[^']+'|[^\s,|]+)+)/
  constructor: (tagName, markup, tokens) ->
    parts = markup.match(@tagSyntax)
    if parts
      @to = parts[1]
      @from = parts[2]
    else
      throw ("Syntax error in 'assign' - Valid syntax: assign [var] = [source]")
    super tagName, markup, tokens

  render: (context) ->
    context.scopes[context.scopes.length-1][@to.toString()] = context.get(@from)
    ""

Liquid.Template.registerTag "assign", Liquid.Tags.Assign
