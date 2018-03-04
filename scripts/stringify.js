const lockfile = require('@yarnpkg/lockfile');
const util = require('./util');

util.processStdin().then((stdin) => {
  util.out({
    'type': 'success',
    'yarnlock': lockfile.stringify(JSON.parse(stdin))
  });
}).catch((e) => {
  util.out({type: 'failure', reason: e.name + ': ' + e.message});
  process.exit(1);
});
