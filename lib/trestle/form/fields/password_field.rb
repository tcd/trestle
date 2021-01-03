class Trestle::Form::Fields::PasswordField < Trestle::Form::Fields::FormControl

  # @return [Doc::HTML]
  def field
    builder.raw_password_field(name, options)
  end

  def defaults
    super.merge(autocomplete: "new-password")
  end

end

Trestle::Form::Builder.register(:password_field, Trestle::Form::Fields::PasswordField)
