class SearchFilters

  def initialize(params, cookies, settings)

  settings.each do |key, value|

    if !params[key.to_s].blank?
        cookies.permanent.signed[key] = params[key.to_s]
    elsif !cookies.signed[key].blank?
        params[key.to_s] = cookies.signed[key]
    else
        cookies.permanent.signed[key] = value[0]
        params[key.to_s] = cookies.signed[key]
    end
  end
  end
end