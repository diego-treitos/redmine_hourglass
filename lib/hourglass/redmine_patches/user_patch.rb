module Hourglass
  module RedminePatches
    module UserPatch
      extend ActiveSupport::Concern

      included do
        has_many :hourglass_time_logs, class_name: 'Hourglass::TimeLog'
        has_many :hourglass_time_bookings, :through => :hourglass_time_logs, class_name: 'Hourglass::TimeBooking', source: :time_bookings
        has_one :hourglass_time_tracker, class_name: 'Hourglass::TimeTracker'
      end

      def remove_references_before_destroy
        super
        substitute = ::User.anonymous
        Hourglass::TimeLog.update_all ['user_id = ?', substitute.id], ['user_id = ?', id]
        Hourglass::TimeTracker.update_all ['user_id = ?', substitute.id], ['user_id = ?', id]
      end
    end
  end
end
