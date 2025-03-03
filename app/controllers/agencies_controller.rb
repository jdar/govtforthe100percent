class AgenciesController < ApplicationController
  def index
    agencies = [
["Department of Energy","https://usaid.gov"],
["Department of Interior","https://usaid.gov"],
["FERC","https://usaid.gov"],
["USAID – President’s Emergency Plan for AIDS Relief (PEPFAR)","https://usaid.gov"],
["USAID – Global Health Programs","https://usaid.gov"],
["USAID – Clinical Research Division","https://usaid.gov"],
["USAID – Africa Bureau","https://usaid.gov"],
["USAID – Asia Bureau","https://usaid.gov"],
["USAID – Latin America and the Caribbean Bureau","https://usaid.gov"],
["USAID – Bureau for Humanitarian Assistance","https://usaid.gov"],
["USAID – Bureau for Resilience and Food Security","https://usaid.gov"],
["USAID – Office of US Foreign Disaster Assistance (OFDA)","https://usaid.gov"],
["USAID – Bureau for Democracy, Human Rights, and Governance","https://usaid.gov"],
["USAID – Office of Security","https://usaid.gov"],
["USAID – Information Technology and Cybersecurity Division","https://usaid.gov"],
["USAID – Global Development Lab","https://usaid.gov"],
["USAID – Center for Innovation and Impact","https://usaid.gov"],
["USAID – Bureau for Conflict Prevention and Stabilization","https://usaid.gov"],
["USAID – Bureau for Economic Growth, Education, and Environment","https://usaid.gov"],
["USAID – Office of Food for Peace","https://usaid.gov"],
["USAID – Bureau for Policy, Planning, and Learning","https://usaid.gov"],
["USAID – Office of Transition Initiatives (OTI)","https://usaid.gov"],
      # Add more agencies as needed
    ]
    render json: agencies
  end

end
