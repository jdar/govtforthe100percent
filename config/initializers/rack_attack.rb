class Rack::Attack
    # Use the client's IP address as the discriminator for throttling.
    
    # Throttle all requests from a single IP to 300 requests per 5 minutes.
    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      # Optionally, you can add conditions to exclude specific paths
      req.ip
    end
  
    # Throttle admin login attempts to protect the Devise endpoint.
    throttle('logins/admin', limit: 5, period: 20.seconds) do |req|
      if req.path == '/admins/sign_in' && req.post?
        req.ip
      end
    end
  
    # Optional: Log or notify when a throttle is triggered.
    self.throttled_response = lambda do |env|
      [ 429,  # HTTP status code for "Too Many Requests"
        { 'Content-Type' => 'text/plain' },
        ["Throttle limit reached. Please try again later.\n"]
      ]
    end
  end