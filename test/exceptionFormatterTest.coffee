{expect}    = require 'chai'
exceptionFormatter = require '../src/exceptionFormatter'

DUMMY_EXCETPION = """
    Error: foo
      at Interface.<anonymous> (/Users/jwalton/.nvm/v0.10.32/lib/node_modules/coffee-script/lib/coffee-script/repl.js:66:9)
      at bar (/Users/jwalton/project/node_modules/express/x/y.js:21:4)
      at foo (/Users/jwalton/project/src/x/y.coffee:188:19)
      at ReadStream.Readable.push (_stream_readable.js:127:10)
      at TTY.onread (net.js:528:21)
"""

describe "exceptionFormatter", ->
    it "should format an exception as ASCII` without throwing any exceptions", ->
        exceptionFormatter new Error("foo"), {format: 'ascii'}

    it "should format an exception as ANSI without throwing any exceptions", ->
        exceptionFormatter new Error("foo"), {format: 'ansi'}

    it "should format an exception as HTML without throwing any exceptions", ->
        exceptionFormatter new Error("foo"), {format: 'html'}

    it "should truncate a long exception", ->
        result = exceptionFormatter DUMMY_EXCETPION, {format: 'ascii', maxLines: 1}
        expect(result).to.equal """
            Error: foo
              at Interface.<anonymous> (/Users/jwalton/.nvm/v0.10.32/lib/node_modules/coffee-script/lib/coffee-script/repl.js:66:9)
              [truncated]
        """

    it "should format a stack trace without throwing any exceptions", ->
        exceptionFormatter (new Error("foo")).stack

    it "should correctly format a stack trace as ASCII (and correcty strip the basepath)", ->
        result = exceptionFormatter DUMMY_EXCETPION, {format: "ascii", basepath: '/Users/jwalton/project'}
        expect(result).to.equal """
            Error: foo
              at Interface.<anonymous> (/Users/jwalton/.nvm/v0.10.32/lib/node_modules/coffee-script/lib/coffee-script/repl.js:66:9)
              at bar (./node_modules/express/x/y.js:21:4)
            * at foo (./src/x/y.coffee:188:19)
              at ReadStream.Readable.push (_stream_readable.js:127:10)
              at TTY.onread (net.js:528:21)
        """

    it "should correctly strip the basepath when the basepath is a regex", ->
        result = exceptionFormatter DUMMY_EXCETPION, {format: "ascii", basepath: /\/Users\/jwalton\/project\//}
        expect(result).to.equal """
            Error: foo
              at Interface.<anonymous> (/Users/jwalton/.nvm/v0.10.32/lib/node_modules/coffee-script/lib/coffee-script/repl.js:66:9)
              at bar (./node_modules/express/x/y.js:21:4)
            * at foo (./src/x/y.coffee:188:19)
              at ReadStream.Readable.push (_stream_readable.js:127:10)
              at TTY.onread (net.js:528:21)
        """
