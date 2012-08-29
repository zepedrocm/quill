#= require mocha
#= require chai
#= require jquery
#= require underscore
#= require tandem/editor


describe('Document', ->
  describe('.normalize()', ->
    editor = new Tandem.Editor('editor-container')
    tests = [{
      name: 'initialize empty document'
      before: ''
      expected: '<div><br></div>'
    }, {
      name: 'tranform equivalent styles'
      before:
        '<div>
          <strong>Strong</strong>
          <em>Emphasis</em>
          <strike>Strike</strike>
          <del>Deleted</del>
          <b>Bold</b>
          <i>Italic</i>
          <s>Strike</s>
          <u>Underline</u>
        </div>'
      expected:
        '<div>
          <b>Strong</b>
          <i>Emphasis</i>
          <s>Deleted</s>
          <s>Strike</s>
          <b>Bold</b>
          <i>Italic</i>
          <s>Strike</s>
          <u>Underline</u>
        </div>'
    }, {
      name: 'merge adjacent equal nodes'
      before:
        '<div>
          <b>Bold1</b>
          <b>Bold2</b>
        </div>'
      expected:
        '<div>
          <b>Bold1Bold2</b>
        </div>'
    }, {
      name: 'remove redundant attribute elements'
      before: 
        '<div>
          <b>
            <i>
              <b>Bolder</b>
            </i>
          </b>
        </div>'
      expected:
        '<div>
          <b>
            <i>Bolder</i>
          </b>
        </div>'
    }, {
      name: 'remove redundant elements'
      before: 
        '<div>
          <span>
            <br>
          <span>
        </div>
        <div>
          <span>
            <span>Span</span>
          <span>
        </div>'
      expected: 
        '<div>
          <br>
        </div>
        <div>
          <span>Span</span>
        </div>'
    }, {
      name: 'remove redundant block elements'
      before:
        '<div>
          <div>
            <span>Hey</span>
          </div>
        </div>
        <div>
          <div>
            <div>
              <div>
                <span>What</span>
              </div>
            </div>
          </div>
        </div>'
      expected:
        '<div>
          <span>Hey</span>
        </div>
        <div>
          <span>What</span>
        </div>'
    }, {
      name: 'break block elements'
      before: 
        '<div>
          <div>
            <span>Hey</span>
          </div>
          <h1>
            <span>What</span>
          </h1>
        </div>'
      expected: 
        '<div>
          <span>Hey</span>
        </div>
        <div>
          <span>What</span>
        </div>'
    }]
    # TODO test disallowed tags

    _.each(tests, (test) ->
      it('shoud ' + test.name, ->
        editor.iframeDoc.body.innerHTML = Tandem.Utils.cleanHtml(test.before)
        editor.doc.rebuildLines()
        expect(editor.iframeDoc.body.innerHTML).to.equal(Tandem.Utils.cleanHtml(test.expected))
      )
    )
  )
)
