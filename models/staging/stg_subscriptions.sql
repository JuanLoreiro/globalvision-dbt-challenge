with source as (

    select * from {{ ref('raw_subscriptions') }}

),

renamed as (

    select
        account_id,
        subscription_id,
        subscription_quantity,
        cast(subscription_deal_close_date as date) as deal_close_date,
        subscription_product_line as product_line,
        subscription_status as status,
        cast(subscription_start_date as date) as start_date,
        cast(subscription_end_date as date) as end_date,
        case 
            when subscription_arr_usd < 0.01 then 0.0
            else cast(subscription_arr_usd as decimal(10,2))
        end as arr_usd
        
    from source

)

select * from renamed
