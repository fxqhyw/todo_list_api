json.attributes do
  json.commentsCount task.comments_count
  json.done task.done
  json.deadline task.deadline
  json.name task.name
  json.position task.position
end
json.relationships do
  json.comments task.comments
end
json.type 'tasks'
