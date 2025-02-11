module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, params: {}, headers: {})
    send method, path, params:, headers:
  end
end
