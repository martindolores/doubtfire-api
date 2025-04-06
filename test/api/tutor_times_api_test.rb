require 'test_helper'

class TutorTimesApiTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include TestHelpers::AuthHelper
  include TestHelpers::JsonHelper

  def app
    Rails.application
  end

  def test_create_tutor_time
    unit = FactoryBot.create(:unit)
    tutor = FactoryBot.create(:user, :tutor)
    project = FactoryBot.create(:project, unit: unit)
    task = FactoryBot.create(:task, project: project)
    unit.employ_staff(tutor, Role.tutor)

    add_auth_header_for(user: tutor)

    data_to_post = {
      user_id: tutor.id,
      task_id: task.id,
      time_spent: 120.00
    }

    post_json "/api/tutor_times", data_to_post

    assert_equal 201, last_response.status

    tutor_time = TutorTime.find_by(id: last_response_body['id'])
    assert_equal data_to_post[:user_id], tutor_time.user_id
    assert_equal data_to_post[:task_id], tutor_time.task_id
    assert_equal data_to_post[:time_spent], tutor_time.time_spent
  end

  def test_update_tutor_time
    unit = FactoryBot.create(:unit)
    tutor = FactoryBot.create(:user, :tutor)
    project = FactoryBot.create(:project, unit: unit)
    task = FactoryBot.create(:task, project: project)
    unit.employ_staff(tutor, Role.tutor)
    puts unit.errors.full_messages
    add_auth_header_for(user: tutor)

    tutor_time = FactoryBot.create(:tutor_time, user: tutor, task: task, time_spent: 120.00)

    data_to_put = {
      user_id: tutor.id,
      task_id: task.id,
      time_spent: 150.00
    }

    put_json "/api/tutor_times/#{tutor_time.id}", data_to_put

    assert_equal 200, last_response.status

    updated_tutor_time = TutorTime.find_by(id: tutor_time.id)
    assert_equal data_to_put[:user_id], updated_tutor_time.user_id
    assert_equal data_to_put[:task_id], updated_tutor_time.task_id
    assert_equal data_to_put[:time_spent], updated_tutor_time.time_spent
  end
end
