class AgenciesController < ApplicationController
  def index
    agencies = [
"Department of Energy",
"Department of Interior",
"FERC",
"USAID – President’s Emergency Plan for AIDS Relief (PEPFAR)",
"USAID – Global Health Programs",
"USAID – Clinical Research Division",
"USAID – Africa Bureau",
"USAID – Asia Bureau",
"USAID – Latin America and the Caribbean Bureau",
"USAID – Bureau for Humanitarian Assistance",
"USAID – Bureau for Resilience and Food Security",
"USAID – Office of US Foreign Disaster Assistance (OFDA)",
"USAID – Bureau for Democracy, Human Rights, and Governance",
"USAID – Office of Security",
"USAID – Information Technology and Cybersecurity Division",
"USAID – Global Development Lab",
"USAID – Center for Innovation and Impact",
"USAID – Bureau for Conflict Prevention and Stabilization",
"USAID – Bureau for Economic Growth, Education, and Environment",
"USAID – Office of Food for Peace",
"USAID – Bureau for Policy, Planning, and Learning",
"USAID – Office of Transition Initiatives (OTI)",
      # Add more agencies as needed
    ]
    render json: agencies
  end

end
