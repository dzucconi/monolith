config = require '../config/config'
Entry = require '../models/entry'
Collection = require '../core/collection'

module.exports = class Entries extends Collection
  model: Entry

  url: "#{config.EUROPA_ENDPOINT}/api/entries"

  comparator: (model) ->
    -(parseInt model.get('created_time'))
