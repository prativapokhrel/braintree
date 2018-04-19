module ApplicationHelper
  def user_alert_converter(alert_type)
    response = ""
    if alert_type=="notice"
      response = "alert alert-info"
    elsif alert_type=="error"
      response = "alert alert-danger"
    elsif alert_type=="alert"
      response = "alert alert-warning"
    elsif alert_type=="success"
      response = "alert alert-success"
    else
      response = "alert alert-info"
    end
    return response
  end
end
