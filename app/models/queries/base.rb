module Queries
  class Base
    def call
      ::ActiveRecord::Base.connection.execute(query.to_sql)
    end

    private

    def paychecks_arel
      @paychecks_arel ||= ::Paycheck.arel_table
    end
  end
end