class Trestle::Form::Fields::TimeField < Trestle::Form::Fields::FormControl

  include Trestle::Form::Fields::DatePicker

    # @return [Doc::HTML]
  def field
    builder.raw_time_field(name, options)
  end

  def default_icon
    icon("fa fa-clock-o")
  end
end

Trestle::Form::Builder.register(:time_field, Trestle::Form::Fields::TimeField)
