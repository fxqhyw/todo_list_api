json.data do
  json.partial! 'task', collection: @tasks, as: :task
end
