require 'grape'

class TutorTimesApi < Grape::API
  helpers AuthenticationHelpers
  helpers AuthorisationHelpers

  format :json
  prefix :api

  before do
    authenticated?
  end

  resource :tutor_times do
    desc "Record marking time for a task"

    params do
      requires :user_id, type: Integer, desc: "User ID (tutor or student)"
      requires :task_id, type: Integer, desc: "Task ID"
      requires :time_spent, type: BigDecimal, desc: "Time spent (in minutes)"
    end

    post do
      task = Task.find_by(id: params[:task_id])
      unless task
        error!({ error: "Task not found" }, 404)
      end

      unless authorise?(current_user, task, :record_marking_time)
        error!({ error: "You are not authorized to record marking time for this task" }, 403)
      end

      tutor_time = TutorTime.new(
        user_id: params[:user_id],
        task_id: params[:task_id],
        time_spent: params[:time_spent]
      )

      if tutor_time.save
        present tutor_time, with: Entities::TutorTimeEntity
      else
        error!({ errors: tutor_time.errors.full_messages }, 422)
      end
    end

    desc "Update marking time for a task"

    params do
      requires :id, type: Integer, desc: "TutorTime ID"
      optional :user_id, type: Integer, desc: "User ID (optional)"
      optional :task_id, type: Integer, desc: "Task ID (optional)"
      optional :time_spent, type: BigDecimal, desc: "Time spent (in minutes) (optional)"
    end

    put ':id' do
      tutor_time = TutorTime.find_by(id: params[:id])

      unless tutor_time
        error!({ error: "TutorTime not found" }, 404)
      end

      unless authorise?(current_user, tutor_time.task, :update_marking_time)
        error!({ error: "You are not authorized to update marking time for this task" }, 403)
      end

      tutor_time.user_id = params[:user_id] if params[:user_id]
      tutor_time.task_id = params[:task_id] if params[:task_id]
      tutor_time.time_spent = params[:time_spent] if params[:time_spent]

      if tutor_time.save
        present tutor_time, with: Entities::TutorTimeEntity
      else
        error!({ errors: tutor_time.errors.full_messages }, 422)
      end
    end
  end
end
