module FindByEmail
  # Returns handle with a given email.
  def find_by_email(email)
    response = request('FindByEmail', {
      'email' => email
    })

    if response.empty?
      nil
    else
      entity = build
      entity.partial = true
      entity.persisted = true
      entity.handle = response
      entity.email = response[:email]
      entity
    end
  end
end
