module Queries
  module Bonus
    class ByNoStreak < ::Queries::Base
      def call(order: nil, where: nil)
        q = query
        q.where(no_bonus_streak_cte_arel[:name].matches("%#{where}%")) if where.present?
        ::Employee.from("(#{q.to_sql}) as #{::Employee.table_name}")
      end

      private

      def query
        max_streak_per_user = ::Arel::Nodes::NamedFunction.new('MAX',
                                                               [no_bonus_streak_cte_arel[:streak]]).as('streak')

        no_bonus_streak_cte_arel.project(no_bonus_streak_cte_arel[:name],
                                         max_streak_per_user)
                                .with(months_without_bonuses_cte,
                                      no_bonus_streak_cte)
                                .group(no_bonus_streak_cte_arel[:name])
                                .where(no_bonus_streak_cte_arel[:streak].not_eq(nil))
      end

      def no_bonus_streak_cte_arel
        @no_bonus_streak_cte_arel ||= ::Arel::Table.new(:no_bonus_streak)
      end

      def no_bonus_streak_cte
        start_end_streak = ::Arel::Nodes::NamedFunction.new('AGE',
                                                            [months_without_bonuses_cte_arel[:next_month_without_bonus],
                                                             months_without_bonuses_cte_arel[:pay_month]])

        monthly_streak = ::Arel::Nodes::Extract.new(start_end_streak, 'MONTH')
                                               .as('streak')

        cte_body = months_without_bonuses_cte_arel.project(months_without_bonuses_cte_arel[Arel.star],
                                                           monthly_streak)

        ::Arel::Nodes::As.new(no_bonus_streak_cte_arel, cte_body)
      end

      def months_without_bonuses_cte_arel
        @months_without_bonuses_cte_arel ||= ::Arel::Table.new(:months_without_bonuses)
      end

      def months_without_bonuses_cte
        cte_body = pays_current_prev_months_arel.project(pays_current_prev_months_arel[:name],
                                                         pays_current_prev_months_arel[:pay_month])
                                                .order(pays_current_prev_months_arel[:pay_month])

        window = ::Arel::Nodes::Window.new
                                      .order(pays_current_prev_months_arel[:pay_month])
                                      .partition(pays_current_prev_months_arel[:name])
        next_payment = ::Arel::Nodes::NamedFunction.new('LEAD',
                                                        [pays_current_prev_months_arel[:pay_month]])
                                                   .over(window)
                                                   .as('next_month_without_bonus')

        cte_body.project(next_payment)
                .where(pays_current_prev_months_arel[:current_month_bonus].eq(0))

        ::Arel::Nodes::As.new(months_without_bonuses_cte_arel, cte_body)
      end
    end
  end
end
