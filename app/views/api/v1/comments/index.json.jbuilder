json.data do
  json.partial! 'comment', collection: @comments, as: :comment
end
