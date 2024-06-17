# TSG OLAP End-to-End Test

## 概述

TSG OLAP 支持对Logs，Metrics和Files进行端到端业务自检,自检数据流： Smaple Datasets -> Kafka Topic -> FLINK ETL -> Storage DB -> QGW API .

## 环境依赖

- 样例数据生成工具：`e2e-mockdata-generator` ，需要JDK11环境
- Report诊断工具：`Newman`，具体参考[帮助文档](https://learning.postman.com/docs/collections/using-newman-cli/newman-options/)

## 使用方法

### 修改 enviroment.json 配置

`Newman CLI 使用QGW HTTP REST API 输出诊断报告,需要添加访问IP`
```json
[
  {
    "key": "qgw_ip",
    "value": "127.0.0.1",
    "type": "default",
    "enabled": true
  },
  {
    "key": "qgw_port",
    "value": "9999",
    "type": "default",
    "enabled": true
  }
]
```
### 修改e2e_test.sh配置

- 增加每个分中心的kafka broker地址

```shell
  # [data_center_name]:kafka_server_list
  declare -A KAFKA_SERVERS=(
    ["tsg_olap_dc_a"]="192.168.44.11:9092"
    ["tsg_olap_dc_b"]="192.168.44.11:9092"
  )
```
- 增加每个分中心的HOS访问地址
```shell
  # [data_center_name]:hos_endpoint_uri
  declare -A HOS_ENDPOINTS=(
    ["tsg_olap_dc_a"]="192.168.44.11"
    ["tsg_olap_dc_b"]="192.168.44.11"
  )
```

### 命令详解

`./e2e_test.sh -h`

```shell
Usage: ./e2e_test.sh [options]

Options:
  -g <type>           Generate data (logs, metrics, files)
  -d <type>           Run diagnostic report (logs, metrics, files)
  -c                  Clear test data
  -a                  Perform all operations: generate data, run diagnostics, and clear data
  -i <key=value,...>  Set environment variable (data_center, hos_ip)
  -v                  Enable verbose reporting
  -e                  Enable emojitrain reporting
  -h                  Show this help message

Examples:
  ./e2e_test.sh -a -e                                   Perform all operations and enable emojitrain reporting
  ./e2e_test.sh -g logs -i data_center=my_data_center   Generate log data at my_data_center
  ./e2e_test.sh -d logs -v                              Run diagnostics on logs data with verbose reporting
  ./e2e_test.sh -d metrics -v                           Run diagnostics on metrics data with verbose reporting
  ./e2e_test.sh -g logs                                 Generate log data use default data center
  ./e2e_test.sh -c                                      Clear test data
  

```
