#+--------------------------------------------------------------------+
#| blankfilesystem.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013 - 2014
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
fs = require('fs')
path = require('path')
Liquid = require('../liquid')

class Liquid.BlankFileSystem

  readTemplateFile: (path) ->
    throw ("This liquid context does not allow includes.")


class Liquid.LocalFileSystem

  constructor: (@root, @pattern = "_%s.liquid") ->

  readTemplateFile: ($template) ->
    String(fs.readFileSync(path.resolve(@root, $template)))
