module AnalyticsHelper
  def analytics
    Analytics::AnalyticsTracker.backend
  end
end
