const { environment } = require('@rails/webpacker')

const webpack = require("webpack") 

environment.plugins.append("Provide", new webpack.ProvidePlugin({ 
  $: 'jquery',
  jQuery: 'jquery',
  jquery: 'jquery',
  'window.Tether': "tether",
  Popper: ['popper.js', 'default']
}));

const aliasConfig = {
  'jquery': 'jquery/src/jquery',
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);

environment.splitChunks()

module.exports = environment
