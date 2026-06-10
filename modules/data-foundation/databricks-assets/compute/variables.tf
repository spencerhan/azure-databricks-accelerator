variable "custom_tags" {
  description = "Custom tags to apply to the cluster. Should be in key-value format."
  type        = map(string)
  default     = {}
}

variable "autotermination_minutes" {
  description = "Autotermination minutes for the cluster."
  type        = number
}

variable "cluster_name" {
  description = "Name of the Databricks cluster to create."
  type        = string
}


variable "user_group" {
  description = "The user group for the Databricks cluster."
  type        = string
}

variable "databricks_cluster_conf" {
  description = "Configuration for the Databricks cluster."
  type = object({
    spark_version      = string
    node_type_id       = string
    runtime_engine     = string
    num_workers        = number
    data_security_mode = string
    kind               = string
    is_single_node     = bool
  })
  default = {
    spark_version  = "16.4.x-scala2.12"
    node_type_id   = "Standard_NC40ads_H100_v5"
    runtime_engine = "STANDARD"
    # Single node cluster:
    num_workers = 0
    # Security mode / single user:
    data_security_mode = "DATA_SECURITY_MODE_DEDICATED"
    kind               = "CLASSIC_PREVIEW"
    is_single_node     = true
  }
}

variable "spark_conf" {
  description = "Spark configuration for the Databricks cluster."
  type        = map(string)
  default = {
    # Required/typical for single node
    # From your JSON
    "spark.master"                                    = "local[*]"
    "spark.sql.legacy.allowUntypedScalaUDF"           = "true"
    "spark.databricks.unityCatalog.volumes.enabled"   = "true"
    "spark.rpc.message.maxSize"                       = "1024"
    "spark.driver.extraJavaOptions"                   = "-XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+AlwaysPreTouch -XX:G1HeapRegionSize=32M"
    "spark.executor.extraJavaOptions"                 = "-XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+AlwaysPreTouch -XX:G1HeapRegionSize=32M"
    "spark.serializer"                                = "org.apache.spark.serializer.KryoSerializer"
    "spark.sql.adaptive.enabled"                      = "true"
    "spark.sql.adaptive.coalescePartitions.enabled"   = "true"
    "spark.driver.memory"                             = "32g"
    "spark.driver.memoryOverhead"                     = "32g"
    "spark.memory.offHeap.enabled"                    = "true"
    "spark.memory.offHeap.size"                       = "10g"
    "spark.kryoserializer.buffer.max"                 = "2000M"
    "spark.driver.maxResultSize"                      = "4g"
    "spark.executor.memory"                           = "2g"
    "spark.sql.adaptive.advisoryPartitionSizeInBytes" = "128MB"
    "spark.sql.adaptive.skewJoin.enabled"             = "true"
    "spark.dynamicAllocation.enabled"                 = "false"
  }
}
