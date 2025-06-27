/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'ETL layer' schema NVARCHAR(250), dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'ETL' Tables
===============================================================================
*/

USE SangomaCDR

IF OBJECT_ID('bronze.sangoma_cdr', 'U')  IS NOT NULL 
    DROP TABLE bronze.sangoma_cdr;
GO

CREATE TABLE bronze.sangoma_cdr (
    call_date       NVARCHAR(250),
    call_from       NVARCHAR(250),
    destination_id  NVARCHAR(250),
    call_to         NVARCHAR(250),
    call_direction  NVARCHAR(250),
    ring_time       TIME,
    talk_time       TIME,
    total_time      TIME,
    disposition     NVARCHAR(250),
    dest_type       NVARCHAR(250),
    uniqueid        NVARCHAR(250),
    dest_number     NVARCHAR(250),
    dest_answered_by NVARCHAR(250),
    caller_id_name  NVARCHAR(250),
    accountcode     NVARCHAR(250),
    userfield       NVARCHAR(250)
        
);
GO

IF OBJECT_ID('bronze.users', 'U')  IS NOT NULL 
    DROP TABLE bronze.users;
GO

CREATE TABLE bronze.users (
    extension NVARCHAR(250),
    password_user  NVARCHAR(250),
    name_user  NVARCHAR(250),
    voicemail  NVARCHAR(250),
    ringtimer NVARCHAR(250),
    noanswer  NVARCHAR(250),
    recording  NVARCHAR(250),
    outboundcid  NVARCHAR(250),
    sipname NVARCHAR(250),
    noanswer_cid NVARCHAR(250),
    busy_cid NVARCHAR(250),
    chanunavail_cid NVARCHAR(250),
    noanswer_dest NVARCHAR(250),
    busy_dest NVARCHAR(250),
    chanunavail_dest NVARCHAR(250),
    mohclass NVARCHAR(250),
    id NVARCHAR(250),
    tech NVARCHAR(250),
    dial NVARCHAR(250),
    devicetype NVARCHAR(250),
    user_n NVARCHAR(250),
    description_n NVARCHAR(250),
    emergency_cid NVARCHAR(250),
    hint_override NVARCHAR(250),
    cwtone NVARCHAR(250),
    recording_in_external NVARCHAR(250),
    recording_out_external NVARCHAR(250),
    recording_in_internal NVARCHAR(250),
    recording_out_internal NVARCHAR(250),
    recording_ondemand NVARCHAR(250),
    recording_priority NVARCHAR(250),
    answermode NVARCHAR(250),
    intercom NVARCHAR(250),cid_masquerade NVARCHAR(250),concurrency_limit NVARCHAR(250),devicedata NVARCHAR(250),accountcode NVARCHAR(250),aggregate_mwi NVARCHAR(250),allow NVARCHAR(250),avpf NVARCHAR(250),bundle NVARCHAR(250),callerid NVARCHAR(250),context NVARCHAR(250),defaultuser NVARCHAR(250),device_state_busy_at NVARCHAR(250),direct_media NVARCHAR(250),disallow NVARCHAR(250),dtmfmode NVARCHAR(250),force_rport NVARCHAR(250),icesupport NVARCHAR(250),mailbox NVARCHAR(250),match NVARCHAR(250),max_audio_streams NVARCHAR(250),max_contacts NVARCHAR(250),max_video_streams NVARCHAR(250),maximum_expiration NVARCHAR(250),media_encryption NVARCHAR(250),media_encryption_optimistic NVARCHAR(250),media_use_received_transport NVARCHAR(250),message_context NVARCHAR(250),minimum_expiration NVARCHAR(250),mwi_subscription NVARCHAR(250),namedcallgroup NVARCHAR(250),namedpickupgroup NVARCHAR(250),outbound_auth NVARCHAR(250),outbound_proxy NVARCHAR(250),qualifyfreq NVARCHAR(250),refer_blind_progress NVARCHAR(250),remove_existing NVARCHAR(250),rewrite_contact NVARCHAR(250),rtcp_mux NVARCHAR(250),rtp_symmetric NVARCHAR(250),rtp_timeout NVARCHAR(250),rtp_timeout_hold NVARCHAR(250),secret NVARCHAR(250),send_connected_line NVARCHAR(250),sendrpid NVARCHAR(250),sipdriver NVARCHAR(250),timers NVARCHAR(250),timers_min_se NVARCHAR(250),transport NVARCHAR(250),trustrpid NVARCHAR(250),user_eq_phone NVARCHAR(250),media_address NVARCHAR(250),force_callerid NVARCHAR(250),vmexten NVARCHAR(250),webrtc NVARCHAR(250),callwaiting_enable NVARCHAR(250),findmefollow_strategy NVARCHAR(250),findmefollow_grptime NVARCHAR(250),findmefollow_grppre NVARCHAR(250),findmefollow_grplist NVARCHAR(250),findmefollow_annmsg_id NVARCHAR(250),findmefollow_postdest NVARCHAR(250),findmefollow_dring NVARCHAR(250),findmefollow_needsconf NVARCHAR(250),findmefollow_remotealert_id NVARCHAR(250),findmefollow_toolate_id NVARCHAR(250),findmefollow_ringing NVARCHAR(250),findmefollow_pre_ring NVARCHAR(250),findmefollow_voicemail NVARCHAR(250),findmefollow_calendar_id NVARCHAR(250),findmefollow_calendar_match NVARCHAR(250),findmefollow_changecid NVARCHAR(250),findmefollow_fixedcid NVARCHAR(250),findmefollow_enabled NVARCHAR(250),parkpro_pagegroup NVARCHAR(250),voicemail_enable NVARCHAR(250),voicemail_vmpwd NVARCHAR(250),voicemail_email NVARCHAR(250),voicemail_pager NVARCHAR(250),voicemail_options NVARCHAR(250),voicemail_same_exten NVARCHAR(250),disable_star_voicemail NVARCHAR(250),vmx_unavail_enabled NVARCHAR(250),vmx_busy_enabled NVARCHAR(250),vmx_temp_enabled NVARCHAR(250),vmx_play_instructions NVARCHAR(250),vmx_option_0_number NVARCHAR(250),vmx_option_1_number NVARCHAR(250),vmx_option_2_number NVARCHAR(250)
);
GO


IF OBJECT_ID('bronze.locations', 'U')  IS NOT NULL 
    DROP TABLE bronze.locations;
GO

CREATE TABLE bronze.locations (
    loc_code    INT,
    loc_name    NVARCHAR(50)
);
GO



IF OBJECT_ID('bronze.departments', 'U')  IS NOT NULL 
    DROP TABLE bronze.departments;
GO

CREATE TABLE bronze.departments (
    dep_code    INT,
    dep_name    NVARCHAR(50)
);
GO
