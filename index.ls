root = exports ? this

J = $.jade

stringEach = (l) ->
  output = []
  for x in l
    if x.split?
      output.push [$('<span>').text(y).html() for y in x.split("\n")].join('<br>')
    else
      output.push x.toString()
  return output

root.questions = questions = [
  {
    text: 'How many distinct strings are in the language of the regular expression: (0+1+ϵ)(0+1+ϵ)(0+1+ϵ)(0+1+ϵ)'
    type: 'radio'
    options: stringEach [
      81, 12, 31, 32, 16, 64
    ]
  }
  {
    text: 'Consider the string abbbaacc. Which of the following lexical specifications produces the tokenization ab/bb/a/acc ?'
    type: 'checkboxes'
    options: stringEach [
      'b+\nab*\nac*', 'c*\nb+\nab\nac*', 'ab\nb+\nac*', 'a(b + c*)\nb+'
    ]
  }
]

insertQuestion = (question) ->
  body = J('.panel-body')
  body.append J('span').text question.text
  body.append J('br')
  for option in question.options
    body.append J("input(type='radio' style='vertical-align: top; display: inline-block; margin-right: 5px')")
    body.append J("div(style='display: inline-block')").html option
    body.append J('br')
  $('#quizstream').append J('.panel.panel-default').append body  

$(document).ready ->
  console.log 'ready'
  for question in questions
    insertQuestion question
    
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some text')
  #$('#quizstream').append J('.panel.panel-default').append J('.panel-body').text('some more text')
