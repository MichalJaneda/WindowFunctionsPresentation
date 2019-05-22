module Queries
  class Base
    def call
      ::ActiveRecord::Base.connection.execute(query.to_sql)
    end

    private

    def paychecks_arel
      @paychecks_arel ||= ::Paycheck.arel_table
    end

    def pays_current_prev_months_arel
      @pays_current_prev_months_arel ||= ::Arel::Table.new(:pays_current_prev_months)
    end
  end
end