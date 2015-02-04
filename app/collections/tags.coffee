config = require '../config/config'
Tag = require '../models/tag'
Collection = require '../core/collection'

module.exports = class Tags extends Collection
  model: Tag

  url: "#{config.EUROPA_ENDPOINT}/api/tags"
