(function() {
  var ActionPane, Browser, Collection, Condition, ConditionPane, Conditions, Context, ContextItem, ContextPane, Contexts, Extension, ExtensionPane, Extensions, Model, Pane, Socket, View, p;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  p = function() {
    var _ref;
    return (_ref = window.console) != null ? _ref.debug.apply(_ref, arguments) : void 0;
  };
  Backbone.sync = Rubyists.BackboneWebSocketSync;
  Model = (function() {
    __extends(Model, Backbone.Model);
    function Model() {
      Model.__super__.constructor.apply(this, arguments);
    }
    return Model;
  })();
  Collection = (function() {
    __extends(Collection, Backbone.Collection);
    function Collection() {
      Collection.__super__.constructor.apply(this, arguments);
    }
    return Collection;
  })();
  View = (function() {
    __extends(View, Backbone.View);
    function View() {
      View.__super__.constructor.apply(this, arguments);
    }
    return View;
  })();
  Context = (function() {
    __extends(Context, Model);
    function Context() {
      Context.__super__.constructor.apply(this, arguments);
    }
    Context.prototype.url = 'FXC::Context';
    return Context;
  })();
  Contexts = (function() {
    __extends(Contexts, Collection);
    function Contexts() {
      Contexts.__super__.constructor.apply(this, arguments);
    }
    Contexts.prototype.url = 'FXC::Context::Collection';
    Contexts.prototype.model = Context;
    return Contexts;
  })();
  Extension = (function() {
    __extends(Extension, Model);
    function Extension() {
      Extension.__super__.constructor.apply(this, arguments);
    }
    Extension.prototype.url = 'FXC::Extension';
    return Extension;
  })();
  Extensions = (function() {
    __extends(Extensions, Collection);
    function Extensions() {
      Extensions.__super__.constructor.apply(this, arguments);
    }
    Extensions.prototype.url = 'FXC::Extension::Collection';
    Extensions.prototype.model = Extension;
    return Extensions;
  })();
  Condition = (function() {
    __extends(Condition, Model);
    function Condition() {
      Condition.__super__.constructor.apply(this, arguments);
    }
    Condition.prototype.url = 'FXC::Condition';
    return Condition;
  })();
  Conditions = (function() {
    __extends(Conditions, Collection);
    function Conditions() {
      Conditions.__super__.constructor.apply(this, arguments);
    }
    Conditions.prototype.url = 'FXC::Condition::Collection';
    Conditions.prototype.model = Condition;
    return Conditions;
  })();
  Browser = (function() {
    __extends(Browser, View);
    function Browser() {
      Browser.__super__.constructor.apply(this, arguments);
    }
    Browser.prototype.tagName = 'table';
    Browser.prototype.id = 'browser';
    Browser.prototype.template = _.template("<thead>\n  <tr>\n    <th>Context</th>\n    <th>Extension</th>\n    <th>Condition</th>\n    <th>Action</th>\n  </tr>\n  <tbody>\n    <tr>\n      <td class=\"contexts\"></td>\n      <td class=\"extensions\"></td>\n      <td class=\"conditions\"></td>\n      <td class=\"actions\"></td>\n    </tr>\n  </tbody>");
    Browser.prototype.initialize = function() {
      _.bindAll(this, 'render');
      this.contextPane = new ContextPane;
      this.extensionPane = new ExtensionPane;
      this.conditionPane = new ConditionPane;
      return this.actionPane = new ActionPane;
    };
    Browser.prototype.render = function() {
      $(this.el).html(this.template());
      this.$('.contexts').html(this.contextPane.render().el);
      this.$('.extensions').html(this.extensionPane.render().el);
      this.$('.conditions').html(this.conditionPane.render().el);
      this.$('.actions').html(this.actionPane.render().el);
      return this;
    };
    Browser.prototype.showContext = function(context) {
      return context;
    };
    return Browser;
  })();
  Pane = (function() {
    __extends(Pane, View);
    function Pane() {
      Pane.__super__.constructor.apply(this, arguments);
    }
    Pane.prototype.tagName = 'td';
    Pane.prototype.render = function() {
      $(this.el).html(this.template());
      return this;
    };
    return Pane;
  })();
  ContextPane = (function() {
    __extends(ContextPane, View);
    function ContextPane() {
      ContextPane.__super__.constructor.apply(this, arguments);
    }
    ContextPane.prototype.tagName = 'ul';
    ContextPane.prototype.initialize = function() {
      _.bindAll(this, 'renderOne', 'renderAll');
      this.contexts = new Contexts();
      this.contexts.bind('reset', this.renderAll);
      this.contexts.bind('change', this.renderAll);
      return this.contexts.fetch();
    };
    ContextPane.prototype.renderAll = function() {
      $(this.el).html('');
      return this.contexts.each(this.renderOne);
    };
    ContextPane.prototype.renderOne = function(context) {
      var view;
      view = new ContextItem({
        pane: this,
        context: context
      });
      return $(this.el).append(view.render().el);
    };
    ContextPane.prototype.render = function() {
      this.renderAll();
      return this;
    };
    ContextPane.prototype.expand = function(context) {
      return this.options.browser.showContext(context);
    };
    return ContextPane;
  })();
  ContextItem = (function() {
    __extends(ContextItem, View);
    function ContextItem() {
      ContextItem.__super__.constructor.apply(this, arguments);
    }
    ContextItem.prototype.tagName = 'li';
    ContextItem.prototype.className = 'context';
    ContextItem.prototype.events = {
      'click': 'showContext'
    };
    ContextItem.prototype.template = _.template("<%= name %>");
    ContextItem.prototype.initialize = function() {
      return this.context = this.options.context;
    };
    ContextItem.prototype.render = function() {
      $(this.el).html(this.template({
        name: this.context.get('name')
      }));
      return this;
    };
    ContextItem.prototype.showContext = function() {
      this.options.pane.expand(this.context);
      return $(this.el).addClass('active');
    };
    return ContextItem;
  })();
  ExtensionPane = (function() {
    __extends(ExtensionPane, Pane);
    function ExtensionPane() {
      ExtensionPane.__super__.constructor.apply(this, arguments);
    }
    ExtensionPane.prototype.id = 'extensions';
    ExtensionPane.prototype.template = _.template("Extension");
    return ExtensionPane;
  })();
  ConditionPane = (function() {
    __extends(ConditionPane, Pane);
    function ConditionPane() {
      ConditionPane.__super__.constructor.apply(this, arguments);
    }
    ConditionPane.prototype.id = 'conditions';
    ConditionPane.prototype.template = _.template("Condition");
    return ConditionPane;
  })();
  ActionPane = (function() {
    __extends(ActionPane, Pane);
    function ActionPane() {
      ActionPane.__super__.constructor.apply(this, arguments);
    }
    ActionPane.prototype.id = 'actions';
    ActionPane.prototype.template = _.template("Action");
    return ActionPane;
  })();
  Socket = (function() {
    __extends(Socket, Rubyists.Socket);
    function Socket() {
      Socket.__super__.constructor.apply(this, arguments);
    }
    Socket.prototype.onopen = function() {
      var browser;
      browser = new Browser();
      return $('#context-browser').html(browser.render().el);
    };
    return Socket;
  })();
  $(function() {
    return Rubyists.syncSocket = new Socket({
      server: 'ws://localhost:9193'
    });
  });
}).call(this);
