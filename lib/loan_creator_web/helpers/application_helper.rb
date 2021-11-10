require 'pry'
require 'date'

module LoanCreatorWeb
  module ApplicationHelper

    PERIODS_IN_MONTHS = {
      month: 1,
      quarter: 3,
      semester: 6,
      year: 12
    }.freeze

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
        h[:term_dates] = build_term_dates_params if params[:button] == 'update'
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

    def build_term_dates_params
      # need to catch the start date - one period to calculate the first term date due
      start_date = to_right_format(params: 'starts_on', value: params[:starts_on])
      start_date_previous_period = start_date.advance(months: -PERIODS_IN_MONTHS.fetch(params[:period].to_sym))
      to_right_format(params: 'term_dates', value: params[:term_dates]).unshift(start_date_previous_period)
    end
  end
end
