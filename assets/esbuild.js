/* eslint-disable import/no-unresolved */
/* eslint-disable no-console */

const esbuild = require('esbuild');

// Decide which mode to proceed with
let mode = 'build';
process.argv.slice(2).forEach((arg) => {
  if (arg === '--watch') {
    mode = 'watch';
  } else if (arg === '--deploy') {
    mode = 'deploy';
  }
});

// Define esbuild options + extras for watch and deploy
let opts = {
  entryPoints: ['js/app.js'],
  bundle: true,
  logLevel: 'info',
  target: 'es2016',
  outdir: '../priv/static/assets',
};
if (mode === 'watch') {
  opts = {
    watch: true,
    sourcemap: 'inline',
    ...opts,
  };
}
if (mode === 'deploy') {
  opts = {
    minify: true,
    ...opts,
  };
}

// Start esbuild with previously defined options
// Stop the watcher when STDIN gets closed (no zombies please!)
esbuild.build(opts).then((result) => {
  if (mode === 'watch') {
    process.stdin.pipe(process.stdout);
    process.stdin.on('end', () => { result.stop(); });
  }
}).catch((error) => {
  console.log(error);
  process.exit(1);
});
