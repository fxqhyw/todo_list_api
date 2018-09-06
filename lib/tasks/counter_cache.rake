desc 'Counter cache for task has many comments'

task comments_counter: :environment do
  Task.reset_column_information
  Task.find_each do |c|
    Task.reset_counters c.id, :comments
  end
end
