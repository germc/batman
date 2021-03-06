(function() {
  var Batman, cli, connect, fs, getServer, path, utils;
  connect = require('connect');
  path = require('path');
  fs = require('fs');
  cli = require('./cli');
  utils = require('./utils');
  Batman = require('../lib/batman.js');
  getServer = function(options) {
    var server;
    server = connect.createServer(connect.favicon(), connect.logger(), connect.static(process.cwd()), connect.directory(process.cwd()));
    if (options.build) {
      server.use(utils.CoffeeCompiler({
        src: process.cwd(),
        dest: path.join(process.cwd(), options.buildDir)
      }));
    }
    server.use('/batman', connect.static(path.join(__dirname, '..', 'lib')));
    server.listen(options.port, '127.0.0.1');
    return server;
  };
  if (typeof RUNNING_IN_BATMAN !== 'undefined') {
    cli.enable('daemon').setUsage('batman server [OPTIONS]').parse({
      port: ['p', "Port to run HTTP server on", "number", 1047],
      build: ['b', "Build coffeescripts on the fly into the build dir (default is ./build) and serve them as js", "boolean", true],
      'build-dir': [false, "Where to store built coffeescript files (default is ./build)", "path"]
    });
    cli.main(function(args, options) {
      var server;
      Batman.mixin(options, utils.getConfig());
      if (options['build-dir'] != null) {
        options.buildDir = options['build-dir'];
      }
      server = getServer(options);
      return this.ok('Batman is waiting at http://127.0.0.1:' + options.port);
    });
  } else {
    module.exports = getServer;
  }
}).call(this);
