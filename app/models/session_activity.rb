class SessionActivity < ApplicationRecord
  belongs_to :marking_session
  belongs_to :project, optional: true
  belongs_to :task, optional: true
  belongs_to :task_definition, optional: true

  validates :action, presence: { message: "invalid %{action}."}
end
