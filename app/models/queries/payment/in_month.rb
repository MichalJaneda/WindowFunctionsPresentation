module Queries
  module Payment
    class InMonth < ::Queries::Base
      private

      def query
        payments_per_month_cte_arel
          .project(payments_per_month_cte_arel[::Arel.star], windows)
          .with(payments_per_month_cte)
          .order(payments_per_month_cte_arel[:year],
                 payments_per_month_cte_arel[:month])
      end

      def windows
        [
          payed_from_beginning_of_year,
          payed_to_end_of_year,
          average_payment_around
        ]
      end

      def average_payment_around
        framing = Arel::Nodes::Between.new(Arel::Nodes::Rows.new,
                                           Arel::Nodes::Preceding.new(2)
                                             .and(Arel::Nodes::Following.new(2)))

        local_window = window.dup
        local_window.frame(framing)

        average_in_window = ::Arel::Nodes::NamedFunction.new('AVG',
                                                             [payments_per_month_cte_arel[:payment_in_month]])
                                                        .over(local_window)

        ::Arel::Nodes::NamedFunction.new('ROUND',
                                         [average_in_window, 2])
                                    .as('average_payment_around')
      end

      def payed_from_beginning_of_year
        local_window = window.dup

        ::Arel::Nodes::NamedFunction.new('SUM', [payments_per_month_cte_arel[:payment_in_month]])
                                    .over(local_window)
                                    .as('payed_from_beginning_of_year')
      end

      def payed_to_end_of_year
        framing = Arel::Nodes::Between.new(Arel::Nodes::Rows.new,
                                           Arel::Nodes::CurrentRow.new
                                             .and(Arel::Nodes::Following.new))

        local_window = window.dup
        local_window.frame(framing)

        ::Arel::Nodes::NamedFunction.new('SUM',
                                         [payments_per_month_cte_arel[:payment_in_month]])
                                    .over(local_window)
                                    .as('payed_to_end_of_year')
      end

      def window
        ::Arel::Nodes::Window.new
                             .order(window_order)
                             .partition(window_partition)
      end

      def window_order
        @window_order ||= [
          payments_per_month_cte_arel[:year],
          payments_per_month_cte_arel[:month]
        ]
      end

      def window_partition
        @window_partition ||= payments_per_month_cte_arel[:year]
      end

      def payments_per_month_cte_arel
        @payments_per_month_cte ||= ::Arel::Table.new(:payments_per_month)
      end

      def payments_per_month_cte
        payment_in_dollars_expr = ::Arel::Nodes::Division.new(
          ::Arel::Nodes::NamedFunction.new('SUM', [paychecks_arel[:payment_cents]]),
          100
        )

        cte_body = paychecks_arel.project(paychecks_arel[:year],
                                          paychecks_arel[:month],
                                          payment_in_dollars_expr.as('payment_in_month'))
                                 .group(paychecks_arel[:year], paychecks_arel[:month])

        ::Arel::Nodes::As.new(payments_per_month_cte_arel, cte_body)
      end
    end
  end
end
