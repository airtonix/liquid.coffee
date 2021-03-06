// Generated by CoffeeScript 1.7.1
(function() {
  var Liquid,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Liquid = require('../../liquid');

  Liquid.Tags.Cycle = (function(_super) {
    var NamedSyntax, SimpleSyntax;

    __extends(Cycle, _super);

    SimpleSyntax = RegExp("^" + Liquid.StrictQuotedFragment.source);

    NamedSyntax = RegExp("^(" + Liquid.StrictQuotedFragment.source + ")\\s*\\:\\s*(.*)");

    function Cycle(tag, markup, tokens) {
      var $;
      if ($ = markup.match(NamedSyntax)) {
        this.variables = this.variablesFromString($[2]);
        this.name = $[1];
      } else if ($ = markup.match(SimpleSyntax)) {
        this.variables = this.variablesFromString(markup);
        this.name = "'" + (this.variables.toString()) + "'";
      } else {
        throw new Liquid.SyntaxError("Syntax error in 'cycle' - Valid syntax: cycle [name :] var [, var2, var3 ...]");
      }
      Cycle.__super__.constructor.call(this, tag, markup, tokens);
    }

    Cycle.prototype.render = function(context) {
      var output, _base;
      (_base = context.registers).cycle || (_base.cycle = {});
      output = '';
      context.stack((function(_this) {
        return function() {
          var iteration, key, result, _ref;
          key = context.get(_this.name);
          iteration = (_ref = context.registers.cycle[key]) != null ? _ref : 0;
          result = context.get(_this.variables[iteration]);
          iteration += 1;
          if (iteration >= _this.variables.length) {
            iteration = 0;
          }
          context.registers.cycle[key] = iteration;
          return output = result;
        };
      })(this));
      return output;
    };

    Cycle.prototype.variablesFromString = function(markup) {
      var $, varname, _i, _len, _ref, _results;
      _ref = markup.split(',');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        varname = _ref[_i];
        $ = varname.match(RegExp("\\s*(" + Liquid.StrictQuotedFragment.source + ")\\s*"));
        if ($[1]) {
          _results.push($[1]);
        } else {
          _results.push(null);
        }
      }
      return _results;
    };

    return Cycle;

  })(Liquid.Tag);

  Liquid.Template.registerTag("cycle", Liquid.Tags.Cycle);

}).call(this);
