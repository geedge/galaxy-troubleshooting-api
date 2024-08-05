#!/bin/bash
#BASE_DIR=$(cd $(dirname $0) && pwd)
BASE_DIR="$(dirname "$(pwd)")"
# Check if required tools are installed
if ! command -v java &> /dev/null; then
  echo "Error: Java is not installed."
  exit 1
fi

# Define common variables
E2E_MOCKDATA_GENERATOR_PATH="$BASE_DIR/e2e-mockdata-generator"
CONFIG_PATH="$BASE_DIR/config"
COLLECTION="tsg-olap-e2e-test-collection.json"
ENVIRONMENT="$BASE_DIR/environment.json"
DATA_CENTER="tsg_olap" # Default Data Center 
OTHER_VAR=""
current=`date "+%Y-%m-%d %H:%M:%S"`
timeStamp=`date -d "$current" +%s`
currentTimeStamp=$((timeStamp*1000+10#`date "+%N"`/1000000))

# data_center_name:kafka_server
declare -A  KAFKA_SERVERS=(
  ["tsg_olap"]="192.168.44.11:9092"
  ["tsg_olap_dc_a"]="192.168.44.11:9092"
  ["tsg_olap_dc_b"]="192.168.44.11:9092"
)

# data_center_name:hos_endpoint
HOS_ENDPOINTS=(
  ["tsg_olap"]="192.168.44.11"
  ["tsg_olap_dc_a"]="192.168.44.11"
  ["tsg_olap_dc_b"]="192.168.44.11"
)

log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

generate_logs() {
  log_message "Generating logs for $1 $2 ..."
  local data_center=$1
  local bootstrap_server=$2
  cd $E2E_MOCKDATA_GENERATOR_PATH || { echo "Error: Cannot change directory to $E2E_MOCKDATA_GENERATOR_PATH"; exit 1; }
  declare -A LOGS=(
    ["SESSION-RECORD"]="session_record.dat"
    ["VOIP-RECORD"]="voip_record.dat"
    ["PROXY-EVENT"]="proxy_event.dat"
  )
    for topic in "${!LOGS[@]}"; do
      # Replace the "data_center" value in the file
      sed -i "s/\"data_center\":\"[^\"]*\"/\"data_center\":\"$data_center\"/g" ./datasets/logs/${LOGS[$topic]}
      sed -i "s/\"start_timestamp_ms\":[0-9]*/\"start_timestamp_ms\":$currentTimeStamp/" ./datasets/logs/${LOGS[$topic]}
      sed -i "s/\"end_timestamp_ms\":[0-9]*/\"end_timestamp_ms\":$currentTimeStamp/" ./datasets/logs/${LOGS[$topic]}
      java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --bootstrap_server $bootstrap_server   --topic $topic -f ./datasets/logs/${LOGS[$topic]}
    done
}

generate_metrics() {
  log_message "Generating metrics for $1 $2..."
  local data_center=$1
  local bootstrap_server=$2
  cd $E2E_MOCKDATA_GENERATOR_PATH || { echo "Error: Cannot change directory to $E2E_MOCKDATA_GENERATOR_PATH"; exit 1; }
  declare -A METRICS=(
    ["NETWORK-TRAFFIC-METRIC"]="network_traffic_metric.dat"
    ["POLICY-RULE-METRIC"]="policy_rule_metric.dat"
    ["OBJECT-STATISTICS-METRIC"]="object_statistics_metric.dat"
    ["STATISTICS-RULE-METRIC"]="statistics_rule_metric.dat"
    ["TRAFFIC-SKETCH-METRIC"]="traffic_sketch_metric.dat"
  )
    for topic in "${!METRICS[@]}"; do
      # Replace the "data_center" value in the file
      sed -i "s/\"data_center\":\"[^\"]*\"/\"data_center\":\"$data_center\"/g" ./datasets/metrics/${METRICS[$topic]}
      # Replace the "timestamp_ms" value in the file
      sed -i "s/\"timestamp_ms\":[0-9]*/\"timestamp_ms\":$currentTimeStamp/" ./datasets/metrics/${METRICS[$topic]}

      java -cp e2e-mockdata-generator.jar com.geedgenetworks.LogGenerator --bootstrap_server $bootstrap_server --topic $topic -f ./datasets/metrics/${METRICS[$topic]}
    done
}


generate_files() {
  log_message "Generating files for $1 $2 ..."
  local data_center=$1
  local bootstrap_server=$2
  cd $E2E_MOCKDATA_GENERATOR_PATH || { echo "Error: Cannot change directory to $E2E_MOCKDATA_GENERATOR_PATH"; exit 1; }
  # 123e4567-e89b-12d3-a456-426614174006 troubleshooting_pcapng
  # 123e4567-e89b-12d3-a456-426614174007 datapath_telemetry_pcapng
  declare -A FILES=(
    ["123e4567-e89b-12d3-a456-426614174001"]="traffic_pcapng"
    ["123e4567-e89b-12d3-a456-426614174002"]="html"
    ["123e4567-e89b-12d3-a456-426614174003"]="html"
    ["123e4567-e89b-12d3-a456-426614174004"]="eml"
    ["123e4567-e89b-12d3-a456-426614174005"]="traffic_pcapng"
  )
    for uuid in "${!FILES[@]}"; do
      java -cp e2e-mockdata-generator.jar com.geedgenetworks.FileChunkGenerator --bootstrap_server $bootstrap_server --topic TRAFFIC-FILE-STREAM-RECORD -n $uuid --file_type ${FILES[$uuid]}
    done
}


# Define function to run diagnostic report
  # -folder logs ：对日志进行故障诊断，输出诊断明细；指定data_center。
  # -folder metrics：对Metrics进行故障诊断，输出诊断明细；指定data_center。
  # -folder files：对文件进行故障诊断，输出诊断明细；指定分中心HOS访问地址。
  # -folder logs：对日志进行故障诊断，通过表情形式输出测试结果
  # -folder files：对文件进行故障诊断，通过表情形式输出测试结果
  #  newman run ./tsg-olap-e2e-test-collection.json -n 1 --delay-request 500 -e $ENVIRONMENT --env-var "data_center=$DATA_CENTER" --ignore-redirects --folder logs -r emojitrain
  #  newman run ./tsg-olap-e2e-test-collection.json -n 1 --delay-request 500 -e $ENVIRONMENT --env-var "hos_ip=$HOS_IP" --ignore-redirects --folder files -r emojitrain
run_diagnostic() {
  log_message "Running diagnostic for $1..."
  cd $BASE_DIR || { echo "Error: Cannot change directory to $BASE_DIR"; exit 1; }
  local folder=$1
  local env_var=$2
  local verbose=""
  local emojitrain=""
  if $verbose_flag; then
    verbose="--verbose"
  fi

  if $emojitrain_flag; then
    emojitrain="-r emojitrain"
  fi

  # Split the env_var string by comma and prepare the env_var_str
  IFS=',' read -ra env_vars <<< "$env_var"
  local env_var_str=""
  for var in "${env_vars[@]}"; do
    env_var_str+="--env-var $var "
  done
  
   newman run $CONFIG_PATH/tsg-olap-e2e-test-collection.json -g $CONFIG_PATH/globals.json -n 1 -e $CONFIG_PATH/environment.json --delay-request 500 --timeout-script 10000 --timeout-request 300000 --timeout 3600000 --insecure $verbose --ignore-redirects $env_var_str --folder $folder $emojitrain
}

clear_data() {
  log_message "Clearing test data..."
  newman run $CONFIG_PATH/tsg-olap-e2e-test-collection.json -g $CONFIG_PATH/globals.json -n 1 --delay-request 500 -e $CONFIG_PATH/environment.json --ignore-redirects --folder clear_test_data -r emojitrain
}

# Help message
show_help() {
  echo ""
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  -g <type>       Generate data (logs, metrics, files)"
  echo "  -d <type>       Run diagnostic report (logs, metrics, files)"
  echo "  -c              Clear test data"
  echo "  -a              Perform all operations: generate data, run diagnostics, and clear data"
  echo "  -i <key=value,...>"
  echo "                  Set environment variable (data_center, hos_ip)"
  echo "  -v              Enable verbose reporting"
  echo "  -e              Enable emojitrain reporting"
  echo "  -h              Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 -a                                      Perform all operations"
  echo "  $0 -g logs                                 Generate log data"
  echo "  $0 -d metrics -v                           Run diagnostics on metrics data with verbose reporting"
  echo "  $0 -c                                      Clear test data"
  echo "  $0 -g logs -i data_center=my_data_center   Generate log data in my_data_center"
  echo ""
}

# Initialize flags
generate_flag=false
diagnostic_flag=false
verbose_flag=false
emojitrain_flag=false
clear_flag=false
all_flag=false
generate_type=""
diagnostic_type=""


# Parse command-line arguments
while getopts ":g:d:i:acveh" opt; do
  case $opt in
    g)
      generate_type=$OPTARG
      generate_flag=true
      ;;
    d)
      diagnostic_type=$OPTARG
      diagnostic_flag=true
      ;;    
    c)
      clear_flag=true
      ;;
    a)
      all_flag=true
      ;;
    i)
      # Split the input based on whitespace, then further split by '=' to assign key-value pairs
      IFS=',' read -ra vars <<< "$OPTARG"
      for var in "${vars[@]}"; do
        # Remove leading and trailing whitespaces
        var=$(echo "$var" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        IFS='=' read -r key value <<< "$var"
        case $key in
          data_center) DATA_CENTER=$value ;;
          other_var) OTHER_VAR=$value ;;
          *) echo "Invalid environment variable: $key"; show_help; exit 1 ;;
        esac
      done
      ;;
    v)
      verbose_flag=true
      ;; 
    e)
      emojitrain_flag=true
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
  esac
done


if $generate_flag; then
 case $generate_type in
    logs) generate_logs "$DATA_CENTER" "${KAFKA_SERVERS[$DATA_CENTER]}" ;;
    metrics) generate_metrics "$DATA_CENTER" "${KAFKA_SERVERS[$DATA_CENTER]}" ;;
    files) generate_files "$DATA_CENTER" "${KAFKA_SERVERS[$DATA_CENTER]}" ;;
    *) echo "Invalid generate type"; show_help; exit 1 ;;
  esac
fi

if $diagnostic_flag; then
  case $diagnostic_type in
    logs) run_diagnostic "logs" "data_center=$DATA_CENTER" ;;
    metrics) run_diagnostic "metrics" "data_center=$DATA_CENTER" ;;
    files) run_diagnostic "files" "data_center=$DATA_CENTER,hos_ip=${HOS_ENDPOINTS[$DATA_CENTER]}" ;;
    *) echo "Invalid diagnostic type"; show_help; exit 1 ;;
  esac
fi

if $clear_flag; then
  clear_data
fi

if $all_flag; then
 
  for data_center_var in "${!KAFKA_SERVERS[@]}"; do
     generate_logs "$data_center_var" "${KAFKA_SERVERS[$data_center_var]}"
     generate_metrics "$data_center_var" "${KAFKA_SERVERS[$data_center_var]}"
     generate_files "$data_center_var" "${KAFKA_SERVERS[$data_center_var]}"
     echo "Wait 30 Seconds..."
     sleep 30
     run_diagnostic "logs" "data_center=$data_center_var"
     run_diagnostic "metrics" "data_center=$data_center_var"
     run_diagnostic "files" "data_center=$data_center_var,hos_ip=${HOS_ENDPOINTS[$data_center_var]}" 
     clear_data
 done  
fi

# Display help message if no arguments are passed
if ! $generate_flag && ! $diagnostic_flag && ! $clear_flag && ! $all_flag; then
  show_help
  exit 1
fi

log_message "E2E test execution completed."
