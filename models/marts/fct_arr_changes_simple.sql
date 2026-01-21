with subscriptions as (

    select 
        account_id,
        subscription_id,
        product_line,
        start_date,
        end_date,
        arr_usd,
        status
    from {{ ref('stg_subscriptions') }}

),

date_spine as (

    select 
        '2021-09-30'::date as month_end
    union all select '2021-10-31'::date
    union all select '2021-11-30'::date
    union all select '2021-12-31'::date
    union all select '2022-01-31'::date
    union all select '2022-02-28'::date
    union all select '2022-03-31'::date
    union all select '2022-04-30'::date
    union all select '2022-05-31'::date
    union all select '2022-06-30'::date
    union all select '2022-07-31'::date
    union all select '2022-08-31'::date
    union all select '2022-09-30'::date
    union all select '2022-10-31'::date
    union all select '2022-11-30'::date
    union all select '2022-12-31'::date
    union all select '2023-01-31'::date
    union all select '2023-02-28'::date
    union all select '2023-03-31'::date
    union all select '2023-04-30'::date
    union all select '2023-05-31'::date
    union all select '2023-06-30'::date
    union all select '2023-07-31'::date
    union all select '2023-08-31'::date
    union all select '2023-09-30'::date
    union all select '2023-10-31'::date
    union all select '2023-11-30'::date
    union all select '2023-12-31'::date
    union all select '2024-01-31'::date
    union all select '2024-02-29'::date
    union all select '2024-03-31'::date
    union all select '2024-04-30'::date
    union all select '2024-05-31'::date
    union all select '2024-06-30'::date
    union all select '2024-07-31'::date
    union all select '2024-08-31'::date
    union all select '2024-09-30'::date
    union all select '2024-10-31'::date
    union all select '2024-11-30'::date
    union all select '2024-12-31'::date
    union all select '2025-01-31'::date
    union all select '2025-02-28'::date
    union all select '2025-03-31'::date
    union all select '2025-04-30'::date
    union all select '2025-05-31'::date
    union all select '2025-06-30'::date
    union all select '2025-07-31'::date
    union all select '2025-08-31'::date
    union all select '2025-09-30'::date
    union all select '2025-10-31'::date
    union all select '2025-11-30'::date
    union all select '2025-12-31'::date
    union all select '2026-01-31'::date
    union all select '2026-02-28'::date
    union all select '2026-03-31'::date
    union all select '2026-04-30'::date
    union all select '2026-05-31'::date
    union all select '2026-06-30'::date
    union all select '2026-07-31'::date
    union all select '2026-08-31'::date
    union all select '2026-09-30'::date
    union all select '2026-10-31'::date
    union all select '2026-11-30'::date
    union all select '2026-12-31'::date

),

monthly_arr as (

    select 
        ds.month_end,
        s.account_id,
        s.subscription_id,
        s.product_line,
        s.arr_usd,
        s.status
    from date_spine ds
    cross join subscriptions s
    where s.start_date <= ds.month_end
      and (s.end_date >= ds.month_end or s.end_date is null)
      and s.status in ('active', 'expired')

),

monthly_arr_by_account as (

    select 
        month_end,
        account_id,
        sum(arr_usd) as monthly_arr,
        count(distinct subscription_id) as active_subscriptions,
        count(distinct product_line) as product_lines
    from monthly_arr
    group by month_end, account_id

),

lagged_arr as (

    select 
        month_end,
        account_id,
        monthly_arr,
        active_subscriptions,
        product_lines,
        lag(monthly_arr) over (
            partition by account_id 
            order by month_end
        ) as prev_month_arr,
        lag(active_subscriptions) over (
            partition by account_id 
            order by month_end
        ) as prev_month_subscriptions
    from monthly_arr_by_account

),

arr_changes as (

    select 
        month_end,
        account_id,
        monthly_arr,
        prev_month_arr,
        monthly_arr - coalesce(prev_month_arr, 0) as arr_change,
        active_subscriptions,
        prev_month_subscriptions,
        active_subscriptions - coalesce(prev_month_subscriptions, 0) as subscription_change,
        case 
            when prev_month_arr is null or coalesce(prev_month_arr, 0) = 0 and monthly_arr > 0 then 'New'
            when coalesce(prev_month_arr, 0) > 0 and monthly_arr = 0 then 'Churn'
            when coalesce(prev_month_arr, 0) = 0 and monthly_arr = 0 then 'No-change'
            when monthly_arr > prev_month_arr then 'Upgrade'
            when monthly_arr < prev_month_arr then 'Downgrade'
            else 'No-change'
        end as arr_change_category
    from lagged_arr

)

select 
    month_end,
    account_id,
    monthly_arr,
    prev_month_arr,
    arr_change,
    arr_change_category,
    active_subscriptions,
    prev_month_subscriptions,
    subscription_change,
    extract(year from month_end) as year,
    extract(month from month_end) as month,
    date_trunc('month', month_end) as month_start
from arr_changes
order by month_end, account_id
