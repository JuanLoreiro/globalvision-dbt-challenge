with monthly_arr as (

    select * from {{ ref('int_monthly_arr') }}

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
    from monthly_arr

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
