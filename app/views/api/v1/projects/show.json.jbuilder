json.data do
  json.attributes do
    json.name @project.name
  end
  json.relationships do
    json.tasks @project.tasks
    json.user @project.user, :id, :email
  end
  json.id @project.id
  json.links do
    json.self api_v1_project_url(@project)
  end
  json.type 'projects'
end
