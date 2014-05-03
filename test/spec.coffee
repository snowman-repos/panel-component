panel = require "../src/coffee/index"

describe "Panel Components", ->

	p = ""

	beforeEach ->
		p =  new panel

	it "should do something", ->
		expect(p.something()).toBe "something"