require 'pry'

module LoanCreatorWeb
  module ApplicationHelper
    def fix_params_type(params)
      params = params.merge({ initial_values: {} }) if params[:initial_values].nil?

      {}.tap do |h|
        h[:type] = params[:type]
        h[:realistic_durations] = true unless params[:realistic_durations].nil?
        h[:period] = params[:period]
        h[:amount] = to_right_format(params: 'amount', value: params[:amount])
        h[:annual_interests_rate] = to_right_format(params: 'annual_interests_rate', value: params[:annual_interests_rate])
        h[:starts_on] = to_right_format(params: 'starts_on', value: params[:starts_on])
        h[:duration_in_periods] = to_right_format(params: 'duration_in_periods', value: params[:duration_in_periods])
        h[:term_dates] = to_right_format(params: 'term_dates', value: params[:term_dates]) if params[:button] == 'update'
        # h[:multi_part_interests_calculation] = false unless params[:multi_part_interests_calculation].nil?
        h[:initial_values] = {}.tap do |ivh|
          ivh[:paid_capital] = to_right_format(params: 'paid_capital', value: params[:initial_values][:paid_capital])
          ivh[:paid_interests] = to_right_format(params: 'paid_interests', value: params[:initial_values][:paid_interests])
          ivh[:accrued_delta_interests] = to_right_format(params: 'accrued_delta_interests', value: params[:initial_values][:accrued_delta_interests])
          ivh[:due_interests] = to_right_format(params: 'due_interests', value: params[:initial_values][:due_interests])
          ivh[:starting_index] = to_right_format(params: 'starting_index', value: params[:initial_values][:starting_index])
        end
      end
    end

    def to_right_format(params:, value:)
      case params
      when *values_to_f
        value.to_f
      when 'starts_on'
        value.blank? ? nil : Date.parse(value)
      when 'duration_in_periods'
        value.to_i
      when 'starting_index'
        (value.blank? && value.to_i.zero?) ? nil : value.to_i
      when 'term_dates'
        value.values
      end
    end

    def values_to_f
      %w(
        amount
        annual_interests_rate
        paid_capital
        paid_interests
        accrued_delta_interests
        due_interests
      )
    end

    def selected(params:, value:)
      value == params ? 'selected' : ''
    end

    def number_to_euro(number)
      "#{number} €"
    end

    def checked(params:)
      params ? 'checked' : ''
    end

    def initial_values_for_form(initial_value)
      (initial_value.present? && initial_value.zero?) ? nil : initial_value
    end
  end
end
