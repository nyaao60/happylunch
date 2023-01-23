const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')

// 追加→一旦消去
// const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())

// 消去
// environment.loaders.prepend('vue', vue)

// 追加（ここから）
environment.loaders.prepend('vue',{
  test: /\.vue$/,
  use: [{
      loader: 'vue-loader'
  }]
})

// // 追加→一旦消去
// const { DefinePlugin } = require('webpack')
// environment.plugins.prepend(
//     'Define',
//     new DefinePlugin({
//         __VUE_OPTIONS_API__: true,
//         __VUE_PROD_DEVTOOLS__: true
//     })
// )
// 追加（ここまで）

module.exports = environment
