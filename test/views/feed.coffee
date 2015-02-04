sinon = require 'sinon'
benv = require 'benv'
eco = require 'eco'

describe 'FeedView', ->
  before (done) ->
    benv.setup =>
      benv.expose
        $: benv.require 'jquery'
        _: benv.require 'underscore'
        Backbone: benv.require 'backbone'

      Backbone.$ = $

      done()

  after ->
    benv.teardown()

  beforeEach ->
    @FeedView = require '../../app/views/feed'
    for method in ['play', 'transitionToHoldingPage']
      @FeedView::[method] = sinon.stub()


    sinon.stub _, 'delay', (cab) -> cab()
    sinon.stub Backbone, 'sync'
    $.fn.velocity = sinon.stub()

    @view = new @FeedView
    @view.tags.reset(require '../fixtures/tags')

  afterEach ->
    _.delay.restore()
    Backbone.sync.restore()

  describe '#initialize', ->
    it 'fetches the tags', ->
      Backbone.sync.args[0][1].url.should.containEql '/api/tags'

    it 'fetches entries (once) when successful', ->
      Backbone.sync.callCount.should.equal 1
      Backbone.sync.args[0][2].success()
      Backbone.sync.callCount.should.equal 2
      Backbone.sync.args[0][2].success()
      Backbone.sync.callCount.should.equal 2
      Backbone.sync.args[1][1].url.should.containEql '/api/entries'

  describe '#maybeShowHolder', ->
    beforeEach ->
      @view.entries.reset(require '../fixtures/entries')

    it 'removes an entry from the front of the list', ->
      @view.entries.length.should.equal 8
      @view.maybeShowHolder()
      @view.entries.length.should.equal 7
      @view.transitionToHoldingPage.called.should.be.false

    it 'shows holding page when entry list is exhausted', ->
      @view.entries.reset([require('../fixtures/entries.js')[0]])
      @view.entries.length.should.equal 1
      @view.maybeShowHolder()
      @view.transitionToHoldingPage.called.should.be.true
