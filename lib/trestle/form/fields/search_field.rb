class Trestle::Form::Fields::SearchField < Trestle::Form::Fields::FormControl

  # @return [Doc::HTML]
  def field
    builder.raw_search_field(name, options)
  end

end

Trestle::Form::Builder.register(:search_field, Trestle::Form::Fields::SearchField)
