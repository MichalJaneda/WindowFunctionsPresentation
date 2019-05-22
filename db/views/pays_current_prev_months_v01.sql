SELECT e.id,
       e.name,
       MAKE_DATE(p.year, p.month, 10)              pay_month,
       (p.payment_cents / 10)                      current_month_pay,
       LAG(p.payment_cents / 10) OVER per_employee prev_month_pay,
       (p.bonus_cents / 10)                        current_month_bonus,
       LAG(p.bonus_cents / 10) OVER per_employee   prev_month_bonus
FROM employees e
         INNER JOIN paychecks p ON e.id = p.employee_id WINDOW per_employee AS (PARTITION BY p.employee_id ORDER BY p.year, p.month)
ORDER BY p.year, p.month;