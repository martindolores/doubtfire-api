module Entities
  class TutorTimeEntity < Grape::Entity
    expose :id
    expose :user_id
    expose :task_id
    expose :time_spent
  end
end
