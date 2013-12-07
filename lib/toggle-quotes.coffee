toggleQuotes = (editor) ->
  previousCursorPosition = editor.getCursorBufferPosition()
  range = editor.bufferRangeForScopeAtCursor('.string.quoted')
  text = editor.getTextInBufferRange(range)
  quoteCharacter = text[0]
  oppositeQuoteCharacter = getOppositeQuote(quoteCharacter)
  quoteRegex = new RegExp(quoteCharacter, 'g')
  escapedQuoteRegex = new RegExp("\\\\#{quoteCharacter}", 'g')
  oppositeQuoteRegex = new RegExp(oppositeQuoteCharacter, 'g')

  newText = text
    .replace(oppositeQuoteRegex, "\\#{oppositeQuoteCharacter}")
    .replace(escapedQuoteRegex, quoteCharacter)
  newText = oppositeQuoteCharacter + newText[1...-1] + oppositeQuoteCharacter

  editor.setTextInBufferRange(range, newText)
  editor.setCursorBufferPosition(previousCursorPosition)

getOppositeQuote = (quoteCharacter) ->
  if quoteCharacter is '"'
    "'"
  else
    '"'

module.exports =
  activate: ->
    atom.workspaceView.command 'toggle-quotes:toggle', '.editor', ->
      activePane = atom.workspaceView.getActivePane()
      editor = activePane.activeItem
      toggleQuotes(editor)

  toggleQuotes: toggleQuotes
