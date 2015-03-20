ref = "<%= escape_javascript(render(partial: 'ref', locals: {ref: @ref})) %>"
$('#ref-form').empty()
$('#refs').append(ref)
