#!/bin/bash

names="log_link_visit_action log_visit log_action"


function get_date_string {
    from=$1
    echo $from | cut -d'-' -f2,3,4 | cut -d_ -f1
}

function export_log_visit {
    last_hour=$1
    # log_visit
    sql="
    SELECT
      idvisit,
      idsite,
      hex(idvisitor),
      visit_last_action_time,
      hex(config_id),
      hex(location_ip),
      user_id,
      visit_first_action_time,
      visit_goal_buyer,
      visit_goal_converted,
      visitor_days_since_first,
      visitor_days_since_order,
      visitor_returning,
      visitor_count_visits,
      visit_entry_idaction_name,
      visit_entry_idaction_url,
      visit_exit_idaction_name,
      visit_exit_idaction_url,
      visit_total_actions,
      visit_total_interactions,
      visit_total_searches,
      referer_keyword,
      referer_name,
      referer_type,
      referer_url,
      location_browser_lang,
      config_browser_engine,
      config_browser_name,
      config_browser_version,
      config_device_brand,
      config_device_model,
      config_device_type,
      config_os,
      config_os_version,
      visit_total_events,
      visitor_localtime,
      visitor_days_since_last,
      config_resolution,
      config_cookie,
      config_director,
      config_flash,
      config_gears,
      config_java,
      config_pdf,
      config_quicktime,
      config_realplayer,
      config_silverlight,
      config_windowsmedia,
      visit_total_time,
      location_city,
      location_country,
      location_latitude,
      location_longitude,
      location_region,
      custom_var_k1,
      custom_var_v1,
      custom_var_k2,
      custom_var_v2,
      custom_var_k3,
      custom_var_v3,
      custom_var_k4,
      custom_var_v4,
      custom_var_k5,
      custom_var_v5
    FROM log_visit
    WHERE
      visit_first_action_time >= '$last_hour:00:00'
      and visit_first_action_time <= '$last_hour:59:59'
    INTO OUTFILE '/var/lib/mysql-files/tmp.csv'
    FIELDS ENCLOSED BY ''
    TERMINATED BY '^'
    "

    mysql -uroot matomo -e "$sql"

    filename="log_visit-"${last_hour/ /_}".csv"

    sed -i 's/\\N//g' /var/lib/mysql-files/tmp.csv
    mv -v /var/lib/mysql-files/tmp.csv /home/ubuntu/csv/$filename
    date_string=$(get_date_string $filename)

    aws s3 cp /home/ubuntu/csv/$filename s3://matomo-dump/log_visit/$date_string/$filename
}



function export_log_link_visit_action {
    # log_link_visit_action
    sql="
    SELECT
      idlink_va,
      idsite,
      hex(idvisitor),
      idvisit,
      idaction_url_ref,
      idaction_name_ref,
      custom_float,
      server_time,
      idpageview,
      interaction_position,
      idaction_name,
      idaction_url,
      time_spent_ref_action,
      idaction_event_action,
      idaction_event_category,
      idaction_content_interaction,
      idaction_content_name,
      idaction_content_piece,
      idaction_content_target,
      custom_var_k1,
      custom_var_v1,
      custom_var_k2,
      custom_var_v2,
      custom_var_k3,
      custom_var_v3,
      custom_var_k4,
      custom_var_v4,
      custom_var_k5,
      custom_var_v5,
      uid
    FROM log_link_visit_action
    WHERE
      server_time >= '$last_hour:00:00'
      and server_time <= '$last_hour:59:59'
    INTO OUTFILE '/var/lib/mysql-files/tmp.csv'
    FIELDS ENCLOSED BY ''
    TERMINATED BY '^'
    "

    mysql -uroot matomo -e "$sql"

    filename="log_link_visit_action-"${last_hour/ /_}".csv"

    sed -i 's/\\N//g' /var/lib/mysql-files/tmp.csv
    mv -v /var/lib/mysql-files/tmp.csv /home/ubuntu/csv/$filename
    date_string=$(get_date_string $filename)

    aws s3 cp /home/ubuntu/csv/$filename s3://matomo-dump/log_visit/$date_string/$filename
}

mkdir -p /home/ubuntu/csv

for n in `seq 1`; do
    last_hour="`date -d "-$n hour" +'%Y-%m-%d %H'`"
    echo "Working on: $last_hour"
    export_log_visit "$last_hour"
    export_log_link_visit_action "$last_hour"
done

