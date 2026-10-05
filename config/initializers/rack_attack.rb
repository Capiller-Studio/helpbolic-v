# frozen_string_literal: true

class Rack::Attack
  # Rate limits for contact form submissions (5 submissions per minute per IP)
  throttle("helpbolic/contact/ip", limit: 5, period: 1.minute) do |req|
    if req.post? && req.path.match?(%r{\A(/[a-z]{2}(?:-[A-Za-z]{2,4})?)?/contact\z})
      req.ip
    end
  end

  # Rate limits for article reactions / voting (20 reactions per minute per IP)
  throttle("helpbolic/reactions/ip", limit: 20, period: 1.minute) do |req|
    if req.post? && req.path.match?(%r{\A(/[a-z]{2}(?:-[A-Za-z]{2,4})?)?/articles/[^/]+/reaction\z})
      req.ip
    end
  end

  # Send a 429 response when throttled
  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]

    headers = {
      "RateLimit-Limit" => match_data[:limit].to_s,
      "RateLimit-Remaining" => "0",
      "RateLimit-Reset" => (now + (match_data[:period] - (now % match_data[:period]))).to_s,
      "Content-Type" => "application/json"
    }

    [ 429, headers, [ { error: "Too many requests. Please try again later." }.to_json ] ]
  end
end
